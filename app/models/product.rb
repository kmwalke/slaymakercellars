class Product < ApplicationRecord
  include Xero::Syncable

  validates :name, presence: true, uniqueness: true
  validates :xero_code, presence: true, uniqueness: true
  validates :price_point, presence: true

  has_many :awards
  has_many :xero_sync_errors, as: :syncable

  scope :in_production, -> { where(in_production: true) }

  CATEGORIES = [
    'Flagship',
    'Mazer Series',
    'Dessert',
    'Hydromel'
  ].freeze
end
