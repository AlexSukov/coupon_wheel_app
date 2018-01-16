class SlicesController < ApplicationController
  before_action :set_slice, only: [:update, :destroy]

  def create
    @slice = Slice.new(slice_params)

    respond_to do |format|
      if @slice.save
        format.html { redirect_to root_path, notice: 'slice was successfully created.' }
        format.json { render :show, status: :created, location: @slice }
      else
        format.html { render :new }
        format.json { render json: @slice.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /slices/1
  # PATCH/PUT /slices/1.json
  def update
    respond_to do |format|
      if @slice.update(slice_params)
        format.html { redirect_to root_path, notice: 'slice was successfully updated.' }
        format.json { render :show, status: :ok, location: @slice }
      else
        format.html { render :edit }
        format.json { render json: @slice.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @slice.next.destroy
    @slice.destroy
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_slice
      @slice = Slice.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def slice_params
      params.require(:slice).permit(:lose, :type, :label, :code, :gravity)
    end
end
