FactoryBot.define do
  factory :contact do
    sequence(:name) { |n| "Contact_#{n}" }
    town
  end
end
