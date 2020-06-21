class Contact < ApplicationRecord
  belongs_to :town

  validates :name, presence: true, uniqueness: true
  validates :town_id, presence: true
end
