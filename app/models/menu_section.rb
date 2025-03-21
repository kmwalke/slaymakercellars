class MenuSection < ApplicationRecord
  has_many :subsections, class_name: MenuSubSection.to_s
end