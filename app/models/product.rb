class Product < ApplicationRecord
  validates :name, presence: true
  validates :price_point, presence: true

  has_many :awards

  CATEGORIES = [
    'Flagship',
    'Mazer Series',
    'Dessert'
  ].freeze
end
