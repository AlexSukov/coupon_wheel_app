class AddUrlFiltersToSetting < ActiveRecord::Migration[5.1]
  def change
    add_column :settings, :url_filters, :text, array: true, default: []
  end
end
