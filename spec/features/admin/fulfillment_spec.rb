require 'rails_helper'

describe 'Admin::Fulfillment' do
  describe 'logged out' do
    it 'must be logged in to view admin page' do
      visit admin_fulfillment_path
      expect(page).to have_current_path(login_path, ignore_query: true)
    end

    it 'customers cannot manage fulfillment' do
      login_as_customer
      visit admin_fulfillment_path
      expect(page).to have_current_path(customer_path, ignore_query: true)
    end
  end

  describe 'logged out' do
    let!(:product) { create(:product) }
    let!(:product2) { create(:product) }
    let!(:order) { create(:order) }
    let!(:case_line_item) { create(:line_item, order:, product:) }
    let!(:order2) { create(:order, delivery_date: Date.current + 1) }
    let!(:case_line_item2) do
      create(:line_item, quantity: product.case_size + 1, order: order2, product:)
    end

    it 'opens Admin::Fulfillment' do
      login_as_admin
      visit admin_fulfillment_path

      expect(page).to have_current_path(admin_fulfillment_path, ignore_query: true)
      expect(page).to have_content('Total')
    end
  end
end
