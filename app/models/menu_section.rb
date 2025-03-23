class MenuSection < ApplicationRecord
  has_many :subsections, class_name: 'MenuSubSection'
  belongs_to :page, class_name: 'MenuPage'

  validates :name, presence: true
end
