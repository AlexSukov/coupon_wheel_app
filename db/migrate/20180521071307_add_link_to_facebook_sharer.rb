class AddLinkToFacebookSharer < ActiveRecord::Migration[5.1]
  def change
    add_column :settings, :facebook_link, :string, default: 'https://www.shopify.com'
  end
end
