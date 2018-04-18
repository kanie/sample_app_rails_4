class DailiesController < ApplicationController
  before_action :set_daily, only: %i[update]

  def update
    respond_to do |format|
      if @daily.update(daily_params)
        format.json { head :no_content }
      else
        format.json do
          render json: @daily.errors, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def set_daily
    @daily = Daily.find(params[:id])
  end

  def daily_params
    params.require(:daily).permit(:planed_time, :actual_time)
  end
end