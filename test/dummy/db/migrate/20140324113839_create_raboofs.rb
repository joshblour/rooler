class CreateRaboofs < ActiveRecord::Migration
  def change
    create_table :raboofs do |t|
      t.string :test

      t.timestamps
    end
  end
end
