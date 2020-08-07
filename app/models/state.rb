class State < ApplicationRecord
  has_many :towns

  validates :name, presence: true
  validates :abbreviation, presence: true
end
