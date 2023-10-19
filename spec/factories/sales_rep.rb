FactoryBot.define do
  factory :sales_rep do
    sequence(:name) { |n| "Sales_Rep_#{n}" }
  end
end
