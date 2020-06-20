class Town < ApplicationRecord
  validates :name, presence: true
end
