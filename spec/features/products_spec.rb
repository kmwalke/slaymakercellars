require 'rails_helper'

RSpec.feature 'Products', type: :feature do
  let!(:product) { Product.create(name: 'name1', price_point: 10, description: 'this is the description') }

  scenario 'list products' do
    visit products_path
    expect(page).to have_content(product.name)
  end
end
