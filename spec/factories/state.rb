FactoryBot.define do
  factory :state do
    sequence(:name) { |n| "State_#{n}" }
    abbreviation { 'AS' }
  end
end
