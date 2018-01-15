ShopifyApp.configure do |config|
  config.application_name = "My Shopify App"
  config.api_key = "847a13dd3a1d07b391a0e603fb02c4b5"
  config.secret = "eeafd20e72730e1e997e93e61899255c"
  config.scope = "read_orders, read_products"
  config.embedded_app = true
  config.after_authenticate_job = false
  config.session_repository = Shop
end
