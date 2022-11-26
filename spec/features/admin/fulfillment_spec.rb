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

  describe 'logged in' do
    let(:product) { create(:product) }
    let(:product2) { create(:product) }
    let!(:product3) { create(:product) }
    let(:order) { create(:order) }
    let(:order2) { create(:order, delivery_date: Date.current + 1) }

    describe 'opens Admin::Fulfillment' do
      before do
        create(:line_item, order:, product:)
        create(:line_item, quantity: product.case_size + 1, order: order2, product: product2)
        login_as_admin
        visit admin_fulfillment_path
      end

      it 'renders fulfillment page' do
        expect(page).to have_current_path(admin_fulfillment_path, ignore_query: true)
      end

      it 'shows fulfillment report for product 1' do
        expect(page.body).to include("<td>#{product.name}</td><td class=active>1</td><td class=inactive>0</td>")
      end

      it 'shows fulfillment report for product 2' do
        expect(page.body).to include("<td>#{product2.name}</td><td class=active>1</td><td class=active>1</td>")
      end

      it 'shows fulfillment report for product 3' do
        expect(page.body).to include("<td>#{product3.name}</td><td class=inactive>0</td><td class=inactive>0</td>")
      end
    end
  end
end
