class Shop < ActiveRecord::Base
  include ShopifyApp::SessionStorage
  has_one :setting, dependent: :destroy
end
