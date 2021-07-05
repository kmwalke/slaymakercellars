class Order < ApplicationRecord
  belongs_to :contact
  has_many :line_items

  validates :contact_id, presence: true
  validates :delivery_date, presence: true
end
