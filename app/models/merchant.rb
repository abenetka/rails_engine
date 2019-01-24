class Merchant < ApplicationRecord
  validates_presence_of :name
  has_many :items
  has_many :invoices

  def self.most_revenue(quantity)
    joins(
      'inner join invoices i on i.merchant_id=merchants.id
       inner join invoice_items ii on ii.invoice_id=i.id
       inner join transactions t on t.invoice_id=i.id')
      .select('merchants.*, sum(ii.quantity * ii.unit_price) as revenue')
      .where(t: {result: 0})
      .order('revenue desc')
      .group(:id)
      .limit(quantity)
  end
end
