class SalesRep < ApplicationRecord
  belongs_to :contact

  validates :name, presence: true
end
