FactoryBot.define do
  factory :menu_section do
    sequence(:name) { |n| "Section_#{n}" }
    page { association :menu_page }
  end
end
