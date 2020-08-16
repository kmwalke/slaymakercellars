class Product < ApplicationRecord
  validates :name, presence: true
  validates :price_point, presence: true
end
