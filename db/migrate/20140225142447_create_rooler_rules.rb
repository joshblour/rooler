class CreateRoolerRules < ActiveRecord::Migration
  def change
    create_table :rooler_rules do |t|
      t.string :name
      t.integer :template_id
      t.integer :check_frequency
      t.datetime :last_checked_at
      t.string :klass_name
      t.string :klass_finder_method
      t.string :instance_checker_method

      t.timestamps
    end
  end
end
