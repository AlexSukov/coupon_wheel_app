class HomeController < ShopifyApp::AuthenticatedController
  def index
    @products = ShopifyAPI::Product.find(:all, params: { limit: 10 })
    @webhooks = ShopifyAPI::Webhook.find(:all)
    @discounts = ShopifyAPI::PriceRule.find(:all)
    @customers = ShopifyAPI::Customer.find(:all)
    @shop = Shop.find_by(shopify_domain: ShopifyAPI::Shop.current.domain)
    @settings = Setting.find_or_create_by(shop_id: @shop.id)
    @slices = Slice.where(setting_id: @settings.id)
    @collected_emails = CollectedEmail.where(shop_id: @shop.id)
  end

end
