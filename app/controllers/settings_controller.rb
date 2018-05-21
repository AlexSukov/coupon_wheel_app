class SettingsController < ApplicationController
  before_action :set_setting, only: [:update, :add_url_filter, :remove_url_filter]
  require 'net/http'

  def create
    @setting = Setting.new(setting_params)

    respond_to do |format|
      if @setting.save
        format.html { redirect_to @setting, notice: 'Settings were successfully created.' }
        format.json { render :show, status: :created, location: @setting }
      else
        format.html { render :new }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /settings/1
  # PATCH/PUT /settings/1.json
  def update
    respond_to do |format|
      if @setting.update(setting_params)
        format.html { redirect_to root_path, notice: 'Settings were successfully updated.' }
        format.json { render :show, status: :ok, location: @setting }
      else
        format.html { render :edit }
        format.json { render json: @setting.errors, status: :unprocessable_entity }
      end
    end
  end

  def add_url_filter
    url = params[:url_filters]
    @setting.url_filters.push(url)
    if @setting.save
      render json: { url: url}
    else
      render json: {status: :unprocessable_entity}
    end
  end

  def remove_url_filter
    @setting.url_filters.delete(params[:url_filters])
    if @setting.save
      render json: { status: 'ok' }
    else
      render json: {status: :unprocessable_entity}
    end
  end

  def clientside
    @shop = Shop.find_by(shopify_domain: params[:shop_domain])
    @settings = Setting.find_by(shop_id: @shop.id)
    @slices = Slice.where(setting_id: @settings.id).order("id ASC")
    render json: { shop: @shop, settings: @settings, slices: @slices }
  end

  def mailchimp_api_key_verification
    gibbon = Gibbon::Request.new(api_key: params[:api_key])
    begin
      @mailchimp_lists = gibbon.lists.retrieve
      render json: { mailchimp_lists: @mailchimp_lists }
    rescue Gibbon::MailChimpError => e
      puts "MailChimpError: #{e.message} - #{e.raw_body}"
    end
  end

  def klaviyo_api_key_verification
    uri = URI('https://a.klaviyo.com/api/v1/lists')
    parameters = { api_key: params[:api_key], type: 'list' }
    uri.query = URI.encode_www_form(parameters )
    res = Net::HTTP.get_response(uri)
    if res.is_a?(Net::HTTPSuccess)
      render json: { klaviyo_lists: res.body }
    else
      render json: { errors: res.body }, status: 409
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_setting
      @setting = Setting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def setting_params
      params.require(:setting).permit(:enable, :big_logo, :small_logo, :title_text,
      :disclaimer_text, :guiding_text, :enter_email, :invalid_email_message, :spin_button,
      :close_button, :winning_title, :winning_text, :discount_code_title, :continue_button,
      :copied_message, :reject_discount_button, :free_product_description, :free_product_button,
      :free_product_reject, :discount_coupon_code_bar, :close_button_in_bar, :theme, :background_color,
      :font_color, :bold_text_and_button_color, :win_section_color, :lose_section_color,
      :enable_discount_code_bar, :discount_code_bar_countdown_time, :discount_code_bar_position,
      :enable_progress_bar, :progress_bar_text, :progress_bar_color, :progress_bar_percentage, :progress_bar_position,
      :show_on_desktop, :show_on_mobile, :show_on_desktop_leave_intent, :show_on_mobile_leave_intent,
      :show_on_desktop_after, :show_on_mobile_after, :show_on_desktop_seconds, :show_on_mobile_seconds,
      :show_pull_out_tab, :tab_icon, :do_not_show_app, :discount_coupon_auto_apply, :url_filters,
      :mailchimp_enable, :mailchimp_list_id, :mailchimp_api_key, :klaviyo_enable, :klaviyo_api_key, :klaviyo_list_id, :duo_color,
      :facebook_enable, :facebook_title, :facebook_link, :facebook_desc, :facebook_button, :facebook_text_color, :facebook_button_text_color,
      :facebook_button_color, :facebook_image, :facebook_image_mobile, :default_tab_icon)
    end
end
