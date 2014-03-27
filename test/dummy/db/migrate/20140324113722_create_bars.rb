class CreateBars < ActiveRecord::Migration
  def change
    create_table :bars do |t|
      t.string :test

      t.timestamps
    end
  end
end
