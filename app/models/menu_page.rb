class MenuPage < ApplicationRecord
  has_many :sections, class_name: MenuSection.to_s
end
