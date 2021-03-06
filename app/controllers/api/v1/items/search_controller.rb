class Api::V1::Items::SearchController < ApplicationController

  def index
    render json: ItemSerializer.new(Item.where(item_params))
  end

  def show
    render json: ItemSerializer.new(Item.find_by(item_params))
  end

  private

  def item_params
    params.permit(:name, :id, :description, :unit_price, :created_at, :updated_at)
  end


end
