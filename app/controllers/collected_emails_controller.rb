class CollectedEmailsController < ApplicationController
  before_action :set_collected_email, only: [:show, :edit, :update, :destroy]

  def create
    @shop = Shop.find_by(shopify_domain: params[:shop_domain])
    @email = params[:collected_email]
    @collected_email = CollectedEmail.create(email: @email, shop_id: @shop.id)
    render json: { collected_email: @collected_email }
  end

  def destroy
    @collected_email.destroy
    respond_to do |format|
      format.html { redirect_to collected_emails_url, notice: 'Collected email was successfully destroyed.' }
      format.json { render status: 'ok' }
    end
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
