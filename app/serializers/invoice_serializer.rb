class InvoiceSerializer
  include FastJsonapi::ObjectSerializer
  attributes :status, :id, :customer_id, :merchant_id
end
