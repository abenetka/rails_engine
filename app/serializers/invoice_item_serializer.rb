class InvoiceItemSerializer
  include FastJsonapi::ObjectSerializer
  attributes :quantity, :unit_price, :id, :invoice_id, :item_id
end
