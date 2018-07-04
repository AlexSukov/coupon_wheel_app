class AdminConstraint
  def matches?(request)
    return false unless request.session[:shopify_domain]
    request.session[:shopify_domain] == 'coupon-wheel-test.myshopify.com'
  end
end
