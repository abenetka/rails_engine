class TransactionSerializer
  include FastJsonapi::ObjectSerializer
  attributes :credit_card_number, :result, :invoice_id, :id
end
