class CreateRoolerTemplates < ActiveRecord::Migration
  def change
    create_table :rooler_templates do |t|
      t.string :name
      t.string :to
      t.string :cc
      t.string :subject
      t.text :body

      t.timestamps
    end
  end
end
