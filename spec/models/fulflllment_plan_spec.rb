require 'rails_helper'

RSpec.describe FulfillmentPlan do
  let!(:product) { create(:product) }
  let!(:product2) { create(:product) }
  let!(:order) { create(:order) }
  let!(:case_line_item) { create(:line_item, order:, product:) }
  let!(:order2) { create(:order, delivery_date: Date.current + 1) }
  let!(:case_line_item2) do
    create(:line_item, quantity: product.case_size + 1, order: order2, product:)
  end
  let!(:fulfillment_plan) { described_class.new }

  describe 'methods' do
    it 'lists products' do
      expect(fulfillment_plan.product_names).to eq([product.name, product2.name])
    end

    it 'returns total amount' do
      expect(fulfillment_plan.total_amount(product.name)).to(
        eq(
          cases: 2,
          bottles: 1
        )
      )
    end

    it 'returns amount for a day' do
      expect(fulfillment_plan.amount(product.name, Date.current)).to(
        eq(
          cases: 1,
          bottles: 0
        )
      )
    end
  end
end
