FactoryBot.define do
  factory :item do
    sequence :name do |n|
      "item_#{n}"
    end
    sequence :description  do |n|
      "Here's item #{n}"
    end
    unit_price { |n| ("#{n}".to_i+1)*1.5 }
    merchant
  end
end
