require 'rails_helper'

RSpec.feature 'Admin::Towns', type: :feature do
  describe 'logged out' do
    scenario 'must be logged in to manage towns' do
      visit admin_towns_path
      expect(current_path).to eq(login_path)
    end

    scenario 'customers cannot view admin page' do
      login_as_customer
      visit admin_contacts_path
      expect(current_path).to eq(login_path)
    end
  end

  describe 'logged in' do
    let!(:town) { FactoryBot.create(:town) }

    before :each do
      login_as_admin
    end

    scenario 'list towns' do
      visit admin_towns_path
      expect(page).to have_content(town.name)
    end

    scenario 'create a town' do
      town2 = FactoryBot.build(:town, state: FactoryBot.create(:state))
      visit admin_towns_path

      click_link 'New Town'
      fill_in_form(town2)
      click_button 'Create Town'

      expect(current_path).to eq(admin_towns_path)
      expect(page).to have_content(town2.name)
    end

    scenario 'edit a town' do
      visit admin_towns_path

      click_link town.name
      town.name = 'new name'
      fill_in_form(town)
      click_button 'Update Town'

      expect(current_path).to eq(admin_towns_path)
      expect(page).to have_content(town.name)
    end

    scenario 'delete a town' do
      town_id = town.id
      visit admin_towns_path

      click_link "delete_#{town.id}"
      expect(current_path).to eq(admin_towns_path)
      expect(Town.find_by_id(town_id)).to be_nil
    end
  end

  def fill_in_form(town)
    fill_in 'Name', with: town.name
    select town.state.name, from: 'town_state_id'
  end
end
