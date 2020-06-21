class Town < ApplicationRecord
  belongs_to :state

  validates :name, presence: true
  validates :state_id, presence: true
end
