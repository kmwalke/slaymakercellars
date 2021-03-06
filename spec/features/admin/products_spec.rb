require 'rails_helper'

RSpec.feature 'Admin::Products', type: :feature do
  describe 'logged out' do
    scenario 'must be logged in to manage products' do
      visit admin_products_path
      expect(current_path).to eq(login_path)
    end
  end

  describe 'logged in' do
    let!(:product) { Product.create(name: 'name1', price_point: 10, description: 'this is the description') }

    before :each do
      login
    end

    scenario 'list products' do
      visit admin_products_path
      expect(page).to have_content(product.name)
    end

    scenario 'create a product' do
      product2 = Product.new(name: 'name2', price_point: 10, description: 'this is the description')
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
  end

  def fill_in_form(product)
    fill_in 'Name', with: product.name
    fill_in 'Price point', with: product.price_point
    fill_in 'Description', with: product.description
  end
end
