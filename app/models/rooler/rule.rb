module Rooler
  class Rule < ActiveRecord::Base
    
    # A rule is a map between email templates and objects of a specific class. A rule checks those objects to dermine if the parent email
    # should be sent. A rule can check a specific object on demand, or check the entire class at a certain frequency.
    #
    # The conditions which determine if a rule is met or not is actually defined in the objects class. The rule stores an instance method
    # name, which it can call on a specific object (on demand), and a class method name to search the class for matching objects
    
    belongs_to :template
    has_many :deliveries
    scope :ready_to_be_checked, -> {where("check_frequency IS NOT NULL AND (last_checked_at IS NULL OR (last_checked_at + check_frequency*'1 second'::interval) < now())")}    
    
    # processes this rule. If an object is provided, check that specific object using the instance method, otherwise check entire
    # class using class method. For each positive result add object to delivery queue.
    def process(object=nil)
      results = []
      
      if object
        results << object if check_instance(object)
      else
        results += [find_by_klass].flatten #return an array, even if the klass_finder_method returns a single object
      end
      
      results.each {|result| add_delivery_to_queue(result)}
    end
    
    private 
    
    # sends klass_method to klass. By default will exclude results that already have an entry in the deliveries table FOR THIS RULE
    def find_by_klass(include_delivered = false)
      already_delivered_ids = deliveries.where(deliverable_type: klass.name).pluck(:deliverable_id) unless include_delivered
      
      if already_delivered_ids && already_delivered_ids.any?
        relation = klass.where('id not in (?)', already_delivered_ids)
      else
        # where(true) is to make sure we start with an active record relation object, and not the class
        relation = klass.where(true)
      end
      
      return relation.send(self.klass_finder_method)
    end
    
    # def find_resetable
    #   #find objecs where reset conditions are matched and delete delivery record
    # end
        
    # create record in deliveries table for found objects (unless one already exists)
    def add_delivery_to_queue(object)
      deliveries.create!(deliverable: object)
    end
  
    def check_instance(object)
      raise TypeError unless object.class.name == self.klass_name
      return false if self.deliveries.where(deliverable: object).any?
      return object.send(self.instance_checker_method)
    end
    
    def klass
      @klass ||= self.klass_name.try(:constantize)
      raise RuntimeError, "Couldn't constantize class name" unless @klass
      return @klass
    end
      
  end
end
