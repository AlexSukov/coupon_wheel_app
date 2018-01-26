class AddColorToSlices < ActiveRecord::Migration[5.1]
  def change
    add_column :slices, :color, :string
  end
end
