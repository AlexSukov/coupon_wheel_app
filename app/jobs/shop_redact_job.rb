class ShopRedactJob < ApplicationJob
  queue_as :default

  def perform(shop_domain, webhook)
    @shop = Shop.find_by(shopify_domain: shopify_domain)
    @shop.destroy
  end
end
