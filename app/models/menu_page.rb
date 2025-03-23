class MenuPage < ApplicationRecord
  has_many :sections, class_name: 'MenuSection'

  def name
    "Page #{position}"
  end
end
