require 'rails_helper'

RSpec.feature 'Admin::Products', type: :feature do
  describe 'logged out' do
    scenario 'must be logged in to manage products' do
      visit admin_products_path
      expect(current_path).to eq(login_path)
    end
  end

  describe 'logged in' do
    let!(:product) { FactoryBot.create(:product) }

    before :each do
      login
    end

    scenario 'list products' do
      visit admin_products_path
      expect(page).to have_content(product.name)
    end

    scenario 'create a product' do
      product2 = FactoryBot.build(:product)
      visit admin_products_path

      click_link 'New Product'
      fill_in_form(product2)
      click_button 'Create Product'

      expect(current_path).to eq(admin_products_path)
      expect(page).to have_content(product2.name)
    end

    scenario 'edit a product' do
      visit admin_products_path

      click_link product.name
      product.name = 'new name'
      fill_in_form(product)
      click_button 'Update Product'

      expect(current_path).to eq(admin_products_path)
      expect(page).to have_content(product.name)
    end

    scenario 'delete a product' do
      product_id = product.id
      visit admin_products_path

      click_link "delete_#{product.id}"
      expect(current_path).to eq(admin_products_path)
      expect(Product.find_by_id(product_id)).to be_nil
    end

    describe 'sync' do
      scenario 'shows xero sync errors' do
        message = 'bad email'
        product.xero_sync_errors << XeroSyncError.new(message: message)

        visit admin_products_path

        click_link product.name
        expect(page).to have_content(message)
      end

      scenario 'does not show xero link for unsynced' do
        visit admin_products_path

        click_link product.name
        expect(page).not_to have_content('View in Xero')
      end

      scenario 'shows xero link for synced' do
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
