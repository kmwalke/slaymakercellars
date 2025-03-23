class MenuWinery < ApplicationRecord
  has_many :menu_items, class_name: 'MenuItem'

  validates :name, presence: true
end
