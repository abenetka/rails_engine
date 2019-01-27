class Api::V1::Merchants::RandomController < ApplicationController

  def show
    random_merchant = Merchant.all.sample
    render json: MerchantSerializer.new(random_merchant)
  end


end
