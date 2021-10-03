class Product < ApplicationRecord
  validates :name, presence: true
  validates :price_point, presence: true

  CATEGORIES = {
    flagship: 'Flagship',
    mazer: 'Mazer Series',
    dessert: 'Dessert'
  }.freeze
end
