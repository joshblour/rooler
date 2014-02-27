module Rooler
  class Delivery < ActiveRecord::Base
    belongs_to :deliverable, polymorphic: true
    belongs_to :rule
    has_one :template, through: :rule
    
    validates :rule_id, uniqueness: {scope: [:deliverable_type, :deliverable_id], message: "Rule already processed for this object"}
    
    scope :undelivered, -> {where(delivered_at: nil)}    
  end
end
