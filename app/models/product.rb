class Product < ApplicationRecord
  validates :name, presence: true
  validates :price_point, presence: true

  CATEGORIES = [
    'Flagship',
    'Mazer Series',
    'Dessert'
  ].freeze
end
