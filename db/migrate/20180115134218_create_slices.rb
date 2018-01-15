class CreateSlices < ActiveRecord::Migration[5.1]
  def change
    create_table :slices do |t|
      t.boolean :lose
      t.string :type
      t.string :label
      t.string :code
      t.integer :gravity
      t.belongs_to :setting, foreign_key: true

      t.timestamps
    end
  end
end
