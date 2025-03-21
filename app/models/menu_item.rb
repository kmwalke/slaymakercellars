class MenuItem < ApplicationRecord
  belongs_to :sub_section, class_name: MenuSubSection.to_s
  belongs_to :winery, class_name: MenuWinery.to_s
end