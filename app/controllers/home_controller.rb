class HomeController < ShopifyApp::AuthenticatedController
  before_action :create_recurring_application_charge, only: :index

  def index
    @discounts = ShopifyAPI::PriceRule.find(:all)
    @shop = Shop.find_by(shopify_domain: ShopifyAPI::Shop.current.domain)
    @settings = Setting.find_or_create_by(shop_id: @shop.id)
    @slices = Slice.where(setting_id: @settings.id).order("id ASC")
    @collected_emails = CollectedEmail.where(shop_id: @shop.id).page(params[:page]).per(25)
  end

  def collected_emails_pagination
    @shop = Shop.find_by(shopify_domain: ShopifyAPI::Shop.current.domain)
    @collected_emails = CollectedEmail.where(shop_id: @shop.id).page(params[:page]).per(25)
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

  def create_recurring_application_charge
    unless ShopifyAPI::RecurringApplicationCharge.current
      recurring_application_charge = ShopifyAPI::RecurringApplicationCharge.new(
              name: "Standard Plan",
              price: 4.99,
              return_url: "https://exitwheel.zoomifi.com/activatecharge",
              trial_days: 10)

      if recurring_application_charge.save
        response.headers.delete('X-Frame-Options')
        fullpage_redirect_to recurring_application_charge.confirmation_url
      end
    end
  end

  def activatecharge
    recurring_application_charge = ShopifyAPI::RecurringApplicationCharge.find(request.params['charge_id'])
    if recurring_application_charge.status == "accepted"
      shop = Shop.find_by(shopify_domain: ShopifyAPI::Shop.current.domain)
      settings = Setting.find_or_create_by(shop_id: shop.id)
      recurring_application_charge.activate
      fullpage_redirect_to root_path
    else
      render 'accept_charge'
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
