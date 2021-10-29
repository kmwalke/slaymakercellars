class Product < ApplicationRecord
  include Xero::Syncable

  validates :name, presence: true, uniqueness: true
  validates :xero_code, presence: true, uniqueness: true
  validates :price_point, presence: true

  has_many :awards

  CATEGORIES = [
    'Flagship',
    'Mazer Series',
    'Dessert'
  ].freeze
end
