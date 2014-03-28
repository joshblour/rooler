module Rooler
  class Template < ActiveRecord::Base
    has_many :rules
    has_many :deliveries, as: :deliverable
    validates :name, :to, :subject, :body, presence: true
    
    def test_object
      object = nil
      rules.each do |rule|
        object = rule.send(:find_by_klass).first
        break if object
      end
      object ||= nil
    end
    
    
    def liquid_method_tree
      LiquidInspector.new(test_object.class).tree
    end
    
  end
end
