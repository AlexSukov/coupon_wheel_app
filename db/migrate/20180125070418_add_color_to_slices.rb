class AddColorToSlices < ActiveRecord::Migration[5.1]
  def change
    add_column :slices, :color, :string, default: "#00ff99"
  end
end
