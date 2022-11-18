require 'rails_helper'

RSpec.describe 'Admin::Towns' do
  describe 'logged out' do
    it 'must be logged in to manage towns' do
      visit admin_towns_path
      expect(page).to have_current_path(login_path, ignore_query: true)
    end

    it 'customers cannot view admin page' do
      login_as_customer
      visit admin_towns_path
      expect(page).to have_current_path(customer_path, ignore_query: true)
    end
  end

  describe 'logged in' do
    let!(:town) { create(:town) }

    before do
      login_as_admin
    end

    it 'list towns' do
      visit admin_towns_path
      expect(page).to have_content(town.name)
    end

    it 'create a town' do
      town2 = build(:town, state: create(:state))
      visit admin_towns_path

      click_link 'New Town'
      fill_in_form(town2)
      click_button 'Create Town'

      expect(page).to have_current_path(admin_towns_path, ignore_query: true)
      expect(page).to have_content(town2.name)
    end

    it 'edit a town' do
      visit admin_towns_path

      click_link town.name
      town.name = 'new name'
      fill_in_form(town)
      click_button 'Update Town'

      expect(page).to have_current_path(admin_towns_path, ignore_query: true)
      expect(page).to have_content(town.name)
    end

    it 'delete a town' do
      town_id = town.id
      visit admin_towns_path

      click_link "delete_#{town.id}"
      expect(page).to have_current_path(admin_towns_path, ignore_query: true)
      expect(Town.find_by(id: town_id)).to be_nil
    end
  end

  def fill_in_form(town)
    fill_in 'Name', with: town.name
    select town.state.name, from: 'town_state_id'
  end
end
