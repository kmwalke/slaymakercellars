class Product < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  validate :acceptable_image

  has_one_attached :bottle_image

  private

  def acceptable_image
    errors.add(:bottle_image, 'is required') && return unless bottle_image.attached?

    errors.add(:bottle_image, 'must be < 1MB') unless bottle_image.byte_size <= 1.megabyte
    errors.add(:bottle_image, 'must be a PNG') unless ['image/png'].include?(bottle_image.content_type)
  end
end
