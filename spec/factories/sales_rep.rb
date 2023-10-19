FactoryBot.define do
  factory :sales_rep do
    sequence(:name) { |n| "Sales_Rep_#{n}" }
    sequence(:email) { |n| "Sales_Rep_#{n}@distributor.com" }
  end
end
