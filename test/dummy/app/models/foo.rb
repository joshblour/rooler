class Foo < ActiveRecord::Base
  
  def self.active_record_finder
    self.where(true)
  end
  
  def self.array_finder
    self.where(true).to_a
  end
  
  def self.empty_finder
    []
  end
  
  def self.active_finder
    self.where(active: true)
  end
  
  
end
