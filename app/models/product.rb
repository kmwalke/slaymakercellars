class Product < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validates :xero_id, presence: true, uniqueness: true
  validates :price_point, presence: true

  has_many :awards
  has_many :xero_sync_errors, as: :syncable

  CATEGORIES = [
    'Flagship',
    'Mazer Series',
    'Dessert'
  ].freeze
end
