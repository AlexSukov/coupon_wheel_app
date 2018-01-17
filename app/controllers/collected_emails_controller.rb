class CollectedEmailsController < ApplicationController
  before_action :set_collected_email, only: [:show, :edit, :update, :destroy]

  # GET /collected_emails
  # GET /collected_emails.json
  def index
    @collected_emails = CollectedEmail.all
  end

  # GET /collected_emails/1
  # GET /collected_emails/1.json
  def show
  end

  # GET /collected_emails/new
  def new
    @collected_email = CollectedEmail.new
  end

  # GET /collected_emails/1/edit
  def edit
  end

  # POST /collected_emails
  # POST /collected_emails.json
  def create
    @collected_email = CollectedEmail.new(collected_email_params)

    respond_to do |format|
      if @collected_email.save
        format.html { redirect_to @collected_email, notice: 'Collected email was successfully created.' }
        format.json { render :show, status: :created, location: @collected_email }
      else
        format.html { render :new }
        format.json { render json: @collected_email.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /collected_emails/1
  # PATCH/PUT /collected_emails/1.json
  def update
    respond_to do |format|
      if @collected_email.update(collected_email_params)
        format.html { redirect_to @collected_email, notice: 'Collected email was successfully updated.' }
        format.json { render :show, status: :ok, location: @collected_email }
      else
        format.html { render :edit }
        format.json { render json: @collected_email.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /collected_emails/1
  # DELETE /collected_emails/1.json
  def destroy
    @collected_email.destroy
    respond_to do |format|
      format.html { redirect_to collected_emails_url, notice: 'Collected email was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def create_email
    @shop = Shop.find_by(shopify_domain: params[:shop_domain])
    @email = params[:collected_email]
    @collected_email = CollectedEmail.create(email: @email, shop_id: @shop.id)
    render json: { collected_email: @collected_email }
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
