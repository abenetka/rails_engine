class Api::V1::InvoiceItems::SearchController < ApplicationController

  def show
    render json: InvoiceItemSerializer.new(InvoiceItem.find_by(invoice_items_params))
  end


  def invoice_items_params
    params.permit(:id, :quanity, :unit_price, :created_at, :updated_at)
  end

end
