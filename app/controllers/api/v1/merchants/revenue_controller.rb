class Api::V1::Merchants::RevenueController < ApplicationController

  def index
    render json: { total_revenue: Merchant.total_revenue_by_date(params[:date])}
  end

  def show
    merchant = Merchant.find(params[:id])
    if params[:date]
      data = { data: {revenue: merchant.single_merchant_revenue_by_date(params[:date])}}
    else
      data = { data: {revenue: merchant.total_revenue_for_merchant}}
    end
    render json: data
  end

end
