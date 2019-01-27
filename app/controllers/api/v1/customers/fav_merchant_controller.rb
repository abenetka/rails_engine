class Api::V1::Customers::FavMerchantController < ApplicationController
  def show
    customer = Customer.find(params[:id])
    render json: { data: {favorite_merchant: customer.favorite_merchant}}
  end

end
