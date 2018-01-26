class AddDuoColorToSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :settings, :duo_color, :boolean
  end
end
