require 'rails_helper'

RSpec.describe 'Menu' do
  let!(:menu_section) { create(:menu_section) }
  let!(:menu_sub_section) { create(:menu_sub_section, section: menu_section) }
  let!(:menu_item) { create(:menu_item, sub_section: menu_sub_section) }

  it 'displays the menu section name' do
    visit menu_path

    expect(page).to have_content(menu_section.name)
  end

  it 'displays the menu sub section name' do
    visit menu_path

    expect(page).to have_content(menu_sub_section.name)
  end

  it 'displays the menu item name' do
    visit menu_path

    expect(page).to have_content(menu_item.name)
  end
end
