class MenuSubSection < ApplicationRecord
  belongs_to :section, class_name: 'MenuSection'
  has_many :items, class_name: 'MenuItem'

  validates :name, presence: true
  validates :section_id, presence: true
end
