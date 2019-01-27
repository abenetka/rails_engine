class Api::V1::InvoiceItems::InvoiceController < ApplicationController
  def index
    render json: InvoiceSerializer.new(InvoiceItem.find(params[:id]).invoice)
  end

end
