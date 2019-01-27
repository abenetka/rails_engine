class Api::V1::Items::RandomController < ApplicationController

  def show
    random_item = Item.all.sample
    render json: ItemSerializer.new(random_item)
  end


end
