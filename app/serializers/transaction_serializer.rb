class TransactionSerializer
  include FastJsonapi::ObjectSerializer
  attributes :credit_card_number, :credit_card_expiration_date, :resul, :invoice_id
end
