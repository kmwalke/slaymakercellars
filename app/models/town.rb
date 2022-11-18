class Town < ApplicationRecord
  belongs_to :state

  has_many :contacts

  validates :name, presence: true
end
