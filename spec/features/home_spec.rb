require 'rails_helper'

RSpec.feature 'Home', type: :feature do
  scenario 'displays the homepage' do
    visit root_path

    expect(page).to have_content('Slaymaker Cellars')
  end

  scenario 'product link' do
    visit root_path
    click_link 'Meads'
    expect(current_path).to eq(products_path)
  end

  scenario 'visit link' do
    visit root_path
    click_link 'Visit Us'
    expect(current_path).to eq(visit_path)
  end
end
