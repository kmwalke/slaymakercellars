require 'rails_helper'

RSpec.describe 'Admin::Products' do
  describe 'logged out' do
    it 'must be logged in to manage products' do
      visit admin_products_path
      expect(page).to have_current_path(login_path, ignore_query: true)
    end

    it 'customers cannot view admin page' do
      login_as_customer
      visit admin_products_path
      expect(page).to have_current_path(customer_path, ignore_query: true)
    end
  end

  describe 'logged in' do
    let!(:product) { create(:product) }

    before do
      login_as_admin
    end

    it 'list products' do
      visit admin_products_path
      expect(page.body).to include("\">#{product.name}</a>")
    end

    describe 'create a product' do
      let(:product2) { build(:product) }

      before do
        visit admin_products_path

        click_link 'New Product'
        fill_in_form(product2)
        click_button 'Create Product'
      end

      it 'renders the index page' do
        expect(page).to have_current_path(admin_products_path, ignore_query: true)
      end

      it 'lists the new product' do
        expect(page.body).to include("\">#{product2.name}</a>")
      end
    end

    describe 'edit a product' do
      before do
        visit admin_products_path

        click_link product.name
        product.name = 'new name'
        fill_in_form(product)
        click_button 'Update Product'
      end

      it 'renders the index page' do
        expect(page).to have_current_path(admin_products_path, ignore_query: true)
      end

      it 'shows the new product name' do
        expect(page.body).to include("\">#{product.name}</a>")
      end
    end

    describe 'delete a product' do
      let!(:product_id) { product.id }

      before do
        visit admin_products_path

        click_link "delete_#{product.id}"
      end

      it 'renders the index page' do
        expect(page).to have_current_path(admin_products_path, ignore_query: true)
      end

      it 'deletes the product' do
        expect(Product.find_by(id: product_id)).to be_nil
      end
    end

    describe 'sync' do
      it 'shows xero sync errors' do
        message = 'bad email'
        product.xero_sync_errors << XeroSyncError.new(message:)

        visit admin_products_path

        click_link product.name
        expect(page).to have_content(message)
      end

      it 'does not show xero link for unsynced' do
        visit admin_products_path

        click_link product.name
        expect(page).to have_no_content('View in Xero')
      end

      it 'shows xero link for synced' do
        product.update(xero_id: 'abc123')
        visit admin_products_path

        click_link product.name
        expect(page).to have_content('View in Xero')
      end
    end
  end

  def fill_in_form(product)
    fill_in 'Name', with: product.name
    fill_in 'Price point', with: product.price_point
    fill_in 'Description', with: product.description
    fill_in 'Xero Code', with: product.xero_code
  end
end
