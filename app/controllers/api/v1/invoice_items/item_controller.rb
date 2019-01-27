class Api::V1::InvoiceItems::ItemController < ApplicationController
  def index
    render json: ItemSerializer.new(InvoiceItem.find(params[:id]).item)
  end

end
