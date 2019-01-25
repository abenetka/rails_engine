class Api::V1::Merchants::RevenueController < ApplicationController

  def index
    render json: MerchantSerializer.new(Merchant.total_revenue_by_date(params[:date]))
  end

end
