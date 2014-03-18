class AddBooleanToFoo < ActiveRecord::Migration
  def change
    add_column :foos, :active, :boolean
  end
end
