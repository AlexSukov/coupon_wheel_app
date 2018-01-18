class AddApiKeysToSetting < ActiveRecord::Migration[5.1]
  def change
    add_column :settings, :mailchimp_enable, :boolean
    add_column :settings, :mailchimp_api_key, :string
    add_column :settings, :mailchimp_list_id, :string
    add_column :settings, :klaviyo_enable, :boolean
    add_column :settings, :klaviyo_api_key, :string
    add_column :settings, :klaviyo_list_id, :string
  end
end
