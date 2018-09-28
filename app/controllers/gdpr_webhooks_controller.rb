class GdprWebhooksController < ApplicationController
  protect_from_forgery with: :null_session

  def customers_redact
    params.permit!
    puts params
    CustomersRedactJob.perform_later(shop_domain: shop_domain, webhook: webhook_params.to_h)
    head :ok
  end

  def shop_redact
    params.permit!
    puts params
    ShopRedactJob.perform_later(shop_domain: shop_domain, webhook: webhook_params.to_h)
    head :ok
  end

  private

  def webhook_params
    params.except(:controller, :action, :type)
  end
end
