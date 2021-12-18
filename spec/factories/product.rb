FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "Award_#{n}" }
    price_point { 14 }
    description { 'This is the description' }
    category { Product::CATEGORIES.last }
    xero_code { "#{category}_3"[-6..].upcase }
  end
end
