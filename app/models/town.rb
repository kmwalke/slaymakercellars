class Town < ApplicationRecord
  belongs_to :state

  has_many :contacts

  validates :name, presence: true
  validates :state_id, presence: true
end
