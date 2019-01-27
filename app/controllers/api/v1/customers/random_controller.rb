class Api::V1::Customers::RandomController < ApplicationController

  def show
    random_customer = Customer.all.sample
    render json: CustomerSerializer.new(random_customer)
  end


end
