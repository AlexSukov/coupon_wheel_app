class AddDefaultTabIconToSettings < ActiveRecord::Migration[5.1]
  def change
    add_column :settings, :default_tab_icon, :string, default: 'https://exitwheel.zoomifi.com/tab-icon/tab_icon.png'
  end
end
