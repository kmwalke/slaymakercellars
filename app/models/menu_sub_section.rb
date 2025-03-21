class MenuSubSection < ApplicationRecord
  belongs_to :section, class_name: MenuSection.to_s
  has_many :items, class_name: MenuItem.to_s
end