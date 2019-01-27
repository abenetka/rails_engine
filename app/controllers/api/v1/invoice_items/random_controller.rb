class Api::V1::InvoiceItems::RandomController < ApplicationController

  def show
    random_invoice_item = InvoiceItem.all.sample
    render json: InvoiceItemSerializer.new(random_invoice_item)
  end


end
