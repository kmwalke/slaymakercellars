require 'rails_helper'

RSpec.describe FulfillmentPlan, type: :model do
  let!(:product) { FactoryBot.create(:product) }
  let!(:product2) { FactoryBot.create(:product) }
  let!(:order) { FactoryBot.create(:order) }
  let!(:case_line_item) { FactoryBot.create(:line_item, order: order, product: product) }
  let!(:order2) { FactoryBot.create(:order, delivery_date: Date.current + 1) }
  let!(:case_line_item2) do
    FactoryBot.create(:line_item, quantity: product.case_size + 1, order: order2, product: product)
  end
  let!(:fulfillment_plan) { FulfillmentPlan.new }

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
