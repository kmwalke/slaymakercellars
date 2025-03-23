class MenuItem < ApplicationRecord
  belongs_to :sub_section, class_name: 'MenuSubSection'
  belongs_to :winery, class_name: 'MenuWinery'

  validates :name, presence: true
  validates :sub_section_id, presence: true
end
