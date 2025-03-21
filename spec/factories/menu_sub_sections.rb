FactoryBot.define do
  factory :menu_sub_section do
    sequence(:name) { |n| "Sub_Section_#{n}" }
    section { association :menu_section }
  end
end
