require 'rails_helper'

RSpec.describe FulfillmentPlan do
  let(:product_name) { 'My Product' }
  let(:fulfillment_plan) { described_class.new }

  describe 'methods' do
    before do
      product = create(:product, name: product_name)
      create(:line_item, order: create(:order), product:)
      create(
        :line_item, quantity: product.case_size + 1, order: create(:order, delivery_date: Date.current + 1), product:
      )
    end

    it 'lists products' do
      expect(fulfillment_plan.product_names).to eq(Product.in_production.order(:name).pluck(:name))
    end

    it 'returns total amount' do
      expect(fulfillment_plan.total_amount(product_name)).to(eq(cases: 2, bottles: 1))
    end

    it 'returns amount for a day' do
      expect(fulfillment_plan.amount(product_name, Date.current)).to(eq(cases: 1, bottles: 0))
    end
  end
end
