require 'rails_helper'

RSpec.feature 'Home', type: :feature do
  scenario 'displays the homepage' do
    visit root_path

    expect(page).to have_content('Kenobi')
  end

  scenario 'product link' do
    visit root_path
    click_link 'Products'
    expect(current_path).to eq(products_path)
  end
end
