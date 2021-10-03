require 'rails_helper'

RSpec.feature 'Products', type: :feature do
  let!(:product) do
    Product.create(name: 'product_1', price_point: 14, description: 'This is the description',
                   category: Product::CATEGORIES.last)
  end
  let!(:product_private) do
    Product.create(name: 'product_1', price_point: 14, description: 'This is the description',
                   category: Product::CATEGORIES.first, is_public: false)
  end

  it 'shows the product page' do
    visit products_path

    expect(page).to have_content('Our Meads')
  end

  it 'shows a product in category' do
    visit products_path
    click_link product.category

    expect(page).to have_content(product.name)
  end

  it 'does not show a product in the wrong category' do
    visit products_path

    expect(page).not_to have_content(product.name)
  end

  it 'does not show private products' do
    visit products_path
    click_link product_private.category

    expect(page).not_to have_content(product_private.name)
  end
end
