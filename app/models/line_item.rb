class LineItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true

  def price_point
    return product.price_point if quantity < product.case_size

    case_price
  end

  def case_price
    (product.price_point * (product.case_size - 1)) / product.case_size
  end
end
