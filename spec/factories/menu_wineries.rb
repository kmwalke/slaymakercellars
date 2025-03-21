FactoryBot.define do
  factory :menu_winery do
    sequence(:name) { |n| "Winery_#{n}" }
  end
end
