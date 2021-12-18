FactoryBot.define do
  factory :award do
    sequence(:name) { |n| "Award_#{n}" }
    product
  end
end
