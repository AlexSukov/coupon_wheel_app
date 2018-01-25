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

  def create_discount_code
    @price_rule = ShopifyAPI::PriceRule.new
    @price_rule.title = params[:title]
    @price_rule.target_type = 'line_item'
    @price_rule.target_selection = 'all'
    @price_rule.allocation_method = 'across'
    @price_rule.value_type = params[:value_type]
    @price_rule.value = params[:value]
    @price_rule.customer_selection = 'all'
    @price_rule.starts_at = params[:starts_at]
    @price_rule.once_per_customer = true
    if @price_rule.save
      @discount = ShopifyAPI::DiscountCode.new
      @discount.prefix_options[:price_rule_id] = @price_rule.id
      @discount.code = @price_rule.title
      if @discount.save
        render json: { discount: @price_rule }
      else
        render json: {status: :unprocessable_entity}
      end
    else
      render json: {status: :unprocessable_entity}
    end
  end

  def destroy_discount_code
    @discount = ShopifyAPI::PriceRule.find(params[:id])
    if @discount.destroy
      render json: {status: :ok}
    else
      render json: {status: :unprocessable_entity}
    end
  end
end
