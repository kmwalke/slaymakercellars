class Award < ApplicationRecord
  validates :name, presence: true
  validates :product_id, presence: true

  belongs_to :product
end
