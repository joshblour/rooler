module Rooler
  class Template < ActiveRecord::Base
    has_many :rules
    has_many :deliveries, as: :deliverable
    validates :name, :to, :subject, :body, presence: true
  end
end
