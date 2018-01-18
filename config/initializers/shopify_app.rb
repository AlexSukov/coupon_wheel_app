ShopifyApp.configure do |config|
  config.application_name = "My Shopify App"
  config.api_key = "847a13dd3a1d07b391a0e603fb02c4b5"
  config.secret = "eeafd20e72730e1e997e93e61899255c"
  config.scope = "read_orders, read_products, write_price_rules, read_price_rules, unauthenticated_write_customers, read_customers, write_customers, read_script_tags, write_script_tags"
  config.embedded_app = true
  config.after_authenticate_job = false
  config.session_repository = Shop
  config.scripttags = [
    {event:'onload', src: 'https://d0396494.ngrok.io/assets/coupon_wheel.coffee' }
  ]
end
