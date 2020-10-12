class Product < ApplicationRecord
  validates :name, presence: true, uniqueness: true

  has_one_attached :bottle_image
end
