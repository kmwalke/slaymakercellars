FactoryBot.define do
  factory :menu_section do
    sequence(:name) { |n| "Section_#{n}" }
  end
end
