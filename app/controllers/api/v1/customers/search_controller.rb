class Api::V1::Customers::SearchController < ApplicationController

  def show
    render json: CustomerSerializer.new(Customer.find_by(customer_params))
  end

  private

  def customer_params
    params.permit(:first_name, :last_name, :id, :created_at, :updated_at)
  end


end
