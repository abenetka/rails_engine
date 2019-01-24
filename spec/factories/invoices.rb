FactoryBot.define do
  factory :invoice do
    status { "Shipped" }
    merchant
    customer
  end
end
