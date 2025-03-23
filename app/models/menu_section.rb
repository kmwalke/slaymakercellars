class MenuSection < ApplicationRecord
  has_many :subsections, class_name: MenuSubSection.to_s
  belongs_to :page, class_name: MenuPage.to_s

  validates :name, presence: true
end