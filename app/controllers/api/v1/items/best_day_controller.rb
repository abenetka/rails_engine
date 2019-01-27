class Api::V1::Items::BestDayController < ApplicationController
  def show
    item = Item.find(params[:id])
    render json: { data: {best_day: item.best_date}}
  end

end
