class MenuSubSection < ApplicationRecord
  belongs_to :section, class_name: MenuSection.to_s
  has_many :items, class_name: MenuItem.to_s

  validates :name, presence: true
  validates :section_id, presence: true
end