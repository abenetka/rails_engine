class Customer < ApplicationRecord
  validates_presence_of :first_name, :last_name
  has_many :invoices
  has_many :merchants, through: :invoices

  def favorite_merchant
    Merchant.joins(invoices: :transactions)
      .select('merchants.*, count(transactions.id) as total_transactions')
      .where(transactions: {result: 0}, invoices: {customer_id: self.id})
      .group(:id)
      .order('total_transactions desc')
      .limit(1)
  end

end
