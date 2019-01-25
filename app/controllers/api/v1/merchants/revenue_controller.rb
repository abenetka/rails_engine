class Api::V1::Merchants::RevenueController < ApplicationController

  def index
    render json: { data: {revenue_by_date: {all_merchants: Merchant.total_revenue_by_date(params[:date])}}}
  end

  def show
    merchant = Merchant.find(params[:id])
    render json: { data: {revenue_for_merchant: {merchant: merchant.total_revenue_for_merchant}}}
  end

end
