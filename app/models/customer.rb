class Customer < ApplicationRecord
  validates_presence_of :first_name, :last_name
  has_many :invoices

  def self.successful_transactions
    Customer.joins(invoices: :transactions)
    .where(transactions: {result: 0})
  end
end
