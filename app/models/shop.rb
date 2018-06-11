class Shop < ActiveRecord::Base
  include ShopifyApp::SessionStorage
  has_one :setting, dependent: :destroy
  has_many :collected_emails, dependent: :destroy
end
