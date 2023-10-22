require 'rails_helper'

RSpec.describe 'Home' do
  it 'displays the homepage' do
    visit root_path

    expect(page).to have_content('Slaymaker Cellars')
  end

  it 'story link' do
    visit root_path
    click_link 'Our Story'
    expect(page).to have_current_path(root_path, ignore_query: true)
  end

  it 'contacts link' do
    visit root_path
    click_link 'Where to Buy'
    expect(page).to have_current_path(contacts_path, ignore_query: true)
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

  it 'menu link' do
    visit root_path
    click_link 'Menu'
    expect(page).to have_current_path(menu_path, ignore_query: true)
  end
end
