class MenuWinery < ApplicationRecord
  has_many :menu_items, class_name: MenuItem.to_s

  validates :name, presence: true
end
