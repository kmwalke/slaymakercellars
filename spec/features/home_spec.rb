require 'rails_helper'

RSpec.describe 'Home' do
  it 'displays the homepage' do
    visit root_path

    expect(page).to have_content('Slaymaker Cellars')
  end

  it 'product link' do
    visit root_path
    click_link 'Meads'
    expect(page).to have_current_path(products_path, ignore_query: true)
  end

  it 'visit link' do
    visit root_path
    click_link 'Visit Us'
    expect(page).to have_current_path(visit_path, ignore_query: true)
  end
end
