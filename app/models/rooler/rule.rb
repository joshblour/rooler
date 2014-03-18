module Rooler
  class Rule < ActiveRecord::Base
    
    # A rule is a map between email templates and objects of a specific class. A rule checks those objects to dermine if the parent email
    # should be sent. A rule can check a specific object on demand, or check the entire class at a certain frequency.
    #
    # The conditions which determine if a rule is met or not is actually defined in the objects class. The rule stores an instance method
    # name, which it can call on a specific object (on demand), and a class method name to search the class for matching objects
    
    belongs_to :template
    has_many :deliveries
    scope :ready_to_be_checked, -> {where("last_checked_at IS NULL OR check_frequency IS NULL OR (last_checked_at + check_frequency*'1 second'::interval) < now()")}    
    serialize :method_params
    
    # processes this rule. Check entire class using class method. For each positive result add object to delivery queue.
    def process
      self.send(:find_undelivered_by_klass).each {|result| add_delivery_to_queue(result)}
      self.update_column(:last_checked_at, Time.now)
    end

    def clear_non_applicable_deliveries
      self.deliveries.where(deliverable_id: no_longer_applicable_delivery_ids).destroy_all
    end
    
    private 
    
    # sends klass_method to klass. If the saved rule contains any params, send those as well.
    def find_by_klass
      if self.method_params
        klass.send(self.klass_finder_method, self.method_params)
      else
        klass.send(self.klass_finder_method)
      end
    end
    
    def find_by_klass_ids
      results = find_by_klass
      if results.respond_to?(:id)
        results.pluck(:id)
      elsif results.respond_to?(:map)
        results.map(&:id)
      else
        raise "Cannot determine object ids"
      end
    end
    
    # Try to exclude any objects already delivered. If the result of the klass method is an active record relation, try to chain on a where clause.
    # otherwise iterate through as an array and use reject.
    def find_undelivered_by_klass
      results = find_by_klass
      if results.respond_to?(:where)
        results.where.not(id: already_delivered_ids)
      elsif results.respond_to?(:reject)
        results.reject {|o| already_delivered_ids.include?(o.id)}
      else
        raise "cannot determine which objects where already delivered"
      end
    end
    
    def already_delivered_ids
      self.deliveries.pluck(:deliverable_id)  #just getting the deliverable id lets the finder class and the result class be different
    end
    
    def no_longer_applicable_delivery_ids
      already_delivered_ids - find_by_klass_ids
    end
        
    # create record in deliveries table for found objects (unless one already exists)
    def add_delivery_to_queue(object)
      deliveries.create(deliverable: object)
    end

    def klass
      @klass ||= self.klass_name.try(:constantize)
      raise RuntimeError, "Couldn't constantize class name" unless @klass
      return @klass
    end
      
  end
end
