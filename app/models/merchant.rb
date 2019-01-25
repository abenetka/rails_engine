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

  def self.most_items(quantity)
    joins(invoices: [:invoice_items, :transactions])
    .select('merchants.*, sum(invoice_items.quantity) as most_items')
    .where(transactions: {result: 0})
    .order('most_items desc')
    .group(:id)
    .limit(quantity)
  end

  def self.total_revenue_by_date(date)
    joins(invoices: [:invoice_items, :transactions])
      .where(transactions: {result: 0, updated_at: date})
      .sum('invoice_items.quantity * invoice_items.unit_price')
  end

end
