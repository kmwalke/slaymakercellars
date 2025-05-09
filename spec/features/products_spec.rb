require 'rails_helper'

RSpec.describe 'Products' do
  let!(:product) { create(:product) }
  let!(:product_private) { create(:product, is_public: false) }
  let!(:award) { create(:award, product:) }

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

    expect(page).to have_no_content(product.name)
  end

  it 'does not show private products' do
    visit products_path
    click_link product_private.category

    expect(page).to have_no_content(product_private.name)
  end

  it 'shows the awards for a product' do
    visit products_path
    click_link product.category

    expect(page).to have_content(award.name)
  end
end
