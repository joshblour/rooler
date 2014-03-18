class AddMethodParamsToRoolerRules < ActiveRecord::Migration
  def change
    add_column :rooler_rules, :method_params, :string
  end
end
