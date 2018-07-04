class GdprWebhooksController < ApplicationController

  def customers_redact
    params.permit!
    puts params
    CustomersRedactJob.perform_later(webhook: webhook_params.to_h)
    head :ok
  end

  def shop_redact
    params.permit!
    puts params
    ShopRedactJob.perform_later(webhook: webhook_params.to_h)
    head :ok
  end

  private

  def webhook_params
    params.except(:controller, :action, :type)
  end
end
