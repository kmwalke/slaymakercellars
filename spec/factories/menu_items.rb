FactoryBot.define do
  factory :menu_item do
    sequence(:name) { |n| "Item_#{n}" }
    winery { association :menu_winery }
    sub_section { association :menu_sub_section }
  end
end
