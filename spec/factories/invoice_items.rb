FactoryBot.define do
  factory :invoice_item do
    quantity { |n| ("#{n}".to_i+1)*2 }
    unit_price { |n| ("#{n}".to_i+1)*1.5 }
    item
    invoice
  end
end
