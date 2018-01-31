class CollectedEmailsController < ApplicationController
  before_action :set_collected_email, only: [:show, :edit, :update, :destroy]
  require 'net/http'

  def create
    @shop = Shop.find_by(shopify_domain: params[:shop_domain])
    @email = params[:collected_email]
    @settings = Setting.find_by( shop_id: @shop.id )
    if CollectedEmail.exists?(email: @email)
      render json: { status: 'ok', settings: @settings }
    else
      @collected_email = CollectedEmail.create(email: @email, shop_id: @shop.id)
      if @settings.mailchimp_enable
        gibbon = Gibbon::Request.new(api_key: @settings.mailchimp_api_key)
        gibbon.lists(@settings.mailchimp_list_id).members.create(body: {email_address: @email, status: "subscribed" })
      end
      if @settings.klaviyo_enable
        url = URI("https://a.klaviyo.com/api/v1/list/#{@settings.klaviyo_list_id}/members")
        req = Net::HTTP::Post.new(url)
        req.set_form_data({'api_key'=>"#{@settings.klaviyo_api_key}", 'email'=>"#{@email}", 'confirm_optin'=>false})
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = (url.scheme == "https")
        response = http.request(req)
        puts response.body
      end
      render json: { status: 'ok', settings: @settings}
    end
  end

  def destroy
    @collected_email.destroy
    render json: { status: 'ok'}
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_collected_email
      @collected_email = CollectedEmail.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def collected_email_params
      params.require(:collected_email).permit(:email, :shop_id)
    end
end
