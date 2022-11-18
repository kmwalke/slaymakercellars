require 'rails_helper'

RSpec.describe LineItem do
  it 'requires an order' do
    expect { create(:line_item, order: nil) }.to raise_error(ActiveRecord::NotNullViolation)
  end

  it 'requires a product' do
    expect { create(:line_item, product_id: nil) }.to raise_error(ActiveRecord::NotNullViolation)
  end

  it 'requires a quantity' do
    expect { create(:line_item, order_id: nil) }.to raise_error(ActiveRecord::NotNullViolation)
  end

  describe 'methods' do
    let!(:product) { create(:product) }
    let!(:partial_line_item) { create(:line_item, quantity: 1, product:) }
    let!(:case_line_item) { create(:line_item, quantity: product.case_size, product:) }

    it 'respects case pricing' do
      expect(case_line_item.price_point < product.price_point).to be true
    end

    it 'calculates price point for kegs' do
      product.update(case_size: 1)

      expect(case_line_item.price_point).to eq(product.price_point)
    end

    it 'respects special customer pricing' do
      partial_line_item.order.contact.update(always_gets_case_deal: true)

      expect(partial_line_item.price_point < product.price_point).to be true
    end

    it 'respects non-case pricing' do
      expect(partial_line_item.price_point).to eq(product.price_point)
    end
  end
end
