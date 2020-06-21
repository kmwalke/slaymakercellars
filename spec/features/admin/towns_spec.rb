require 'rails_helper'

RSpec.feature 'Admin::Towns', type: :feature do
  describe 'logged out' do
    scenario 'must be logged in to manage towns' do
      visit admin_towns_path
      expect(current_path).to eq(login_path)
    end
  end

  describe 'logged in' do
    let!(:state) { State.create(name: 'Colorado', abbreviation: 'CO') }
    let!(:town) { Town.create(name: 'Idaho Springs', state: state) }

    before :each do
      login
    end

    scenario 'list towns' do
      visit admin_towns_path
      expect(page).to have_content(town.name)
    end

    scenario 'create a town' do
      town2 = Town.new(name: 'Denver', state: state)
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
