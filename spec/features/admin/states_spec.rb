require 'rails_helper'

RSpec.feature 'Admin::States', type: :feature do
  describe 'logged out' do
    scenario 'must be logged in to manage states' do
      visit admin_states_path
      expect(current_path).to eq(login_path)
    end
  end

  describe 'logged in' do
    let!(:state) { FactoryBot.create(:state) }

    before :each do
      login
    end

    scenario 'list states' do
      visit admin_states_path
      expect(page).to have_content(state.name)
    end

    scenario 'create a state' do
      state2 = FactoryBot.build(:state)
      visit admin_states_path

      click_link 'New State'
      fill_in_form(state2)
      click_button 'Create State'

      expect(current_path).to eq(admin_states_path)
      expect(page).to have_content(state2.name)
    end

    scenario 'edit a state' do
      visit admin_states_path

      click_link state.name
      state.name = 'new name'
      fill_in_form(state)
      click_button 'Update State'

      expect(current_path).to eq(admin_states_path)
      expect(page).to have_content(state.name)
    end

    scenario 'delete a state' do
      state_id = state.id
      visit admin_states_path

      click_link "delete_#{state.id}"
      expect(current_path).to eq(admin_states_path)
      expect(State.find_by_id(state_id)).to be_nil
    end
  end

  def fill_in_form(state)
    fill_in 'Name', with: state.name
    fill_in 'Abbreviation', with: state.abbreviation
  end
end
