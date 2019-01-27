class Api::V1::Invoices::RandomController < ApplicationController

  def show
    random_invoice = Invoice.all.sample
    render json: InvoiceSerializer.new(random_invoice)
  end


end
