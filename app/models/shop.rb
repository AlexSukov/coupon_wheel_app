class Shop < ActiveRecord::Base
  include ShopifyApp::SessionStorage
  has_one :settings, dependent: :destroy
end
