FactoryBot.define do
  factory :line_item do
    product
    quantity { product.case_size }
  end
end
