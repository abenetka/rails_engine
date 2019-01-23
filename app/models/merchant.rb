class Merchant < ApplicationRecord
  has_many :customers
  has_many :items
end
