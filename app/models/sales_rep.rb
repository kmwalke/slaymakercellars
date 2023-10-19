class SalesRep < ApplicationRecord
  belongs_to :contact

  validates :name, presence: true
  validates :contact_id, presence: true
end
