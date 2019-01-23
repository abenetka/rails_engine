FactoryBot.define do
  factory :invoice do
    status { "MyString" }
    association :merchant, factory: :merchant
    association :customer, factory: :customer
  end
end
