class SlicesController < ApplicationController
  before_action :set_slice, only: [:update, :destroy]

  def create
    @slice = Slice.new(slice_params)
    if @slice.save
      render json: { slice: @slice }
    end
  end

  # PATCH/PUT /slices/1
  # PATCH/PUT /slices/1.json
  def update
    if @slice.update(slice_params)
      render json: { slice: @slice }
    end
  end

  def destroy
    @next_slice = Slice.where(["id > ? and setting_id = ?", @slice.id, @slice.setting_id]).first
    @next_slice.destroy
    @slice.destroy
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_slice
      @slice = Slice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def slice_params
      params.require(:slice).permit(:lose, :slice_type, :label, :code, :gravity, :setting_id,
      :product_image)
    end
end
