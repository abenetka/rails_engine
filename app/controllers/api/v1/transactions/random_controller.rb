class Api::V1::Transactions::RandomController < ApplicationController

  def show
    random_transaction = Transaction.all.sample
    render json: TransactionSerializer.new(random_transaction)
  end


end
