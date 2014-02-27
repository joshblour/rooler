# This migration comes from rooler (originally 20140226120323)
class CreateRoolerDeliveries < ActiveRecord::Migration
  def change
    create_table :rooler_deliveries do |t|
      t.string :deliverable_type
      t.integer :deliverable_id
      t.integer :rule_id
      t.datetime :delivered_at

      t.timestamps
    end
  end
end
