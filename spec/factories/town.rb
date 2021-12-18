FactoryBot.define do
  factory :town do
    sequence(:name) { |n| "Town_#{n}" }
    state
  end
end
