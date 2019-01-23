FactoryBot.define do
  factory :invoice_item do
    quantity { 1 }
    unit_price { 1 }
    association :item, factory: :item
    association :invoice, factory: :invoice
  end
end
