class LineItem < ApplicationRecord
  belongs_to :order
  belongs_to :product

  validates :quantity, presence: true

  def price_point
    return case_price if gets_case_price

    product.price_point
  end

  private

  def case_price
    (product.price_point * (product.case_size - 1)) / product.case_size
  end

  def gets_case_price
    quantity >= product.case_size || order.contact.always_gets_case_deal
  end
end
