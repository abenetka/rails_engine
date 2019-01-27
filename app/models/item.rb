class Item < ApplicationRecord
  validates_presence_of :name, :description, :unit_price

  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  belongs_to :merchant

  def self.items_most_revenue(quantity)
    joins(invoices: [:invoice_items, :transactions])
      .select('items.*, sum(invoice_items.quantity * invoice_items.unit_price) as revenue')
      .where(transactions: {result: 0})
      .order('revenue desc')
      .group(:id)
      .limit(quantity)
  end

  def self.top_items(quantity)
    joins(invoices: [:invoice_items, :transactions])
    .select('items.*, sum(invoice_items.quantity) as top_items')
    .where(transactions: {result: 0})
    .order('top_items desc')
    .group(:id)
    .limit(quantity)
  end

  def best_date
    Item.joins(invoices: [:invoice_items, :transactions])
    .select('invoices.updated_at, sum(invoice_items.quantity * invoice_items.unit_price) as total_sales')
    .where(transactions: {result: 0})
    .order('total_sales desc')
    .order('invoices.updated_at desc')
    .group('invoices.updated_at')
    .limit(1)
    .first
    .updated_at
  end

end
