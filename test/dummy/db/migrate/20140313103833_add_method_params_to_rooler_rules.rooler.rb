# This migration comes from rooler (originally 20140313103516)
class AddMethodParamsToRoolerRules < ActiveRecord::Migration
  def change
    add_column :rooler_rules, :method_params, :string
  end
end
