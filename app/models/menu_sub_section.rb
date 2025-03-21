class MenuSubSection < ApplicationRecord
  has_many :items, class_name: MenuItem.to_s
end