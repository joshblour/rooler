class Raboof < ActiveRecord::Base
  belongs_to :bar
  liquid_methods :test, :updated_at
end
