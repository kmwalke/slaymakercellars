FactoryBot.define do
  factory :contact do
    sequence(:name) { |n| "Contact_#{n}" }
    town
    address { '123 main st' }
  end
end
