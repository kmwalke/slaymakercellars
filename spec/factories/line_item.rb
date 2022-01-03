FactoryBot.define do
  factory :line_item do
    product
    order
    quantity { product.case_size }
  end
end
