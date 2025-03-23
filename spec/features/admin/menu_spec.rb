require 'rails_helper'

RSpec.describe 'Admin::Menu' do
  describe 'logged out' do
    it 'must be logged in to view admin page' do
      visit admin_menu_path
      expect(page).to have_current_path(login_path, ignore_query: true)
    end

    it 'customers cannot view admin page' do
      login_as_customer
      visit admin_menu_path
      expect(page).to have_current_path(customer_path, ignore_query: true)
    end
  end

  describe 'logged in' do
    let!(:menu_section) { create(:menu_section) }
    let!(:menu_sub_section) { create(:menu_sub_section, section: menu_section) }
    let!(:menu_item) { create(:menu_item) }

    before do
      login_as_admin
      visit admin_menu_path
    end

    it 'display page' do
      expect(page).to have_content('Menu')
    end

    it 'displays the menu section name' do
      expect(page).to have_content(menu_section.name)
    end

    it 'displays the menu sub section name' do
      expect(page).to have_content(menu_sub_section.name)
    end

    it 'displays the menu item name' do
      expect(page).to have_content(menu_item.name)
    end

    describe 'create items' do
      let(:new_section) { build(:section, page: menu_page) }
      let(:new_sub_section) { build(:sub_section, section: menu_section) }
      let(:new_item) { build(:menu_item, sub_section: menu_sub_section) }

      it 'creates a page' do
        num_pages = Page.count
        click_link 'New Page'
        expect(Page.last.position).to eq(num_pages + 1)
      end

      it 'creates a section' do
        click_link 'New Section'
        fill_in 'Name', with: new_section.name
        select new_section.page.name, from: 'section_page_id'
        click_button 'Create Section'
        expect(page).to have_content(new_section.name)
      end

      it 'creates a sub section' do
        click_link 'New SubSection'
        fill_in 'Name', with: new_sub_section.name
        select new_sub_section.section.name, from: 'sub_section_section_id'
        click_button 'Create SubSection'
        expect(page).to have_content(new_sub_section.name)
      end

      it 'creates a winery' do
        winery = build(:winery, sub_section: menu_sub_section)
        click_link 'New Winery'
        fill_in 'Name', with: winery.name
        click_button 'Create Winery'
        expect(page).to have_content(winery.name)
      end

      it 'creates an item' do
        click_link 'New Item'
        fill_in 'Name', with: new_item.name
        fill_in 'Winery', with: new_item.winery.name
        fill_in 'On Prem Price', with: new_item.on_prem_price
        fill_in 'Off Prem Price', with: new_item.off_prem_price
        select new_item.sub_section.name, from: 'item_sub_section_id'
        click_button 'Create Item'
        expect(page).to have_content(new_menu.name)
      end
    end
  end
end
