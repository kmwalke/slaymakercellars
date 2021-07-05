require 'rails_helper'

RSpec.feature 'Home', type: :feature do
  scenario 'displays the homepage' do
    visit root_path

    expect(page).to have_content('Slaymaker Cellars')
  end

  scenario 'product link', skip: 'product page not implemented' do
    visit root_path
    click_link 'Order'
    expect(current_path).to eq(products_path)
  end

  scenario 'visit link', skip: 'not implemented' do
    visit root_path
    click_link 'Visit Us'
    expect(current_path).to eq(visit_path)
  end
end
