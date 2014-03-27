class Bar < ActiveRecord::Base
  belongs_to :foo
  has_one :raboof
  
  liquid_methods :test, :raboof
  
end
