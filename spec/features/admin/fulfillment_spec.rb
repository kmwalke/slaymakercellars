require 'rails_helper'

describe 'Admin::Fulfillment', type: :feature do
  describe 'logged out' do
    scenario 'must be logged in to view admin page' do
      visit admin_fulfillment_path
      expect(current_path).to eq(login_path)
    end
  end

  describe 'logged out' do
    let!(:product) { FactoryBot.create(:product) }
    let!(:product2) { FactoryBot.create(:product) }
    let!(:order) { FactoryBot.create(:order) }
    let!(:case_line_item) { FactoryBot.create(:line_item, order: order, product: product) }
    let!(:order2) { FactoryBot.create(:order, delivery_date: Date.current + 1) }
    let!(:case_line_item2) do
      FactoryBot.create(:line_item, quantity: product.case_size + 1, order: order2, product: product)
    end

    it 'opens Admin::Fulfillment' do
      login
      visit admin_fulfillment_path

      expect(current_path).to eq(admin_fulfillment_path)
      expect(page).to have_content('Total')
    end
  end
end
