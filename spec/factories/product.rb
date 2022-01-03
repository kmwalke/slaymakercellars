FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "product_#{n}" }
    price_point { 14 }
    case_size { 12 }
    description { 'This is the description' }
    category { Product::CATEGORIES.last }
    xero_code { name[-6..].upcase }
  end
end
