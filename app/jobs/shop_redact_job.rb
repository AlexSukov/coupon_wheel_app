class ShopRedactJob < ApplicationJob
  queue_as :default

  def perform(shop_domain:, webhook:)
    @shop = Shop.find_by(shopify_domain: shop_domain)
    @shop.collected_emails.destroy_all
  end
end
