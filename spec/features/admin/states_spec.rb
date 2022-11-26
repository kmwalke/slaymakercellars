require 'rails_helper'

RSpec.describe 'Admin::States' do
  describe 'logged out' do
    it 'must be logged in to manage states' do
      visit admin_states_path
      expect(page).to have_current_path(login_path, ignore_query: true)
    end

    it 'customers cannot view admin page' do
      login_as_customer
      visit admin_states_path
      expect(page).to have_current_path(customer_path, ignore_query: true)
    end
  end

  describe 'logged in' do
    let!(:state) { create(:state) }

    before do
      login_as_admin
    end

    it 'list states' do
      visit admin_states_path
      expect(page).to have_content(state.name)
    end

    describe 'create a state' do
      let(:state2) { build(:state) }

      before do
        visit admin_states_path

        click_link 'New State'
        fill_in_form(state2)
        click_button 'Create State'
      end

      it 'renders the index page' do
        expect(page).to have_current_path(admin_states_path, ignore_query: true)
      end

      it 'shows the new state' do
        expect(page).to have_content(state2.name)
      end
    end

    describe 'edit a state' do
      before do
        visit admin_states_path

        click_link state.name
        state.name = 'new name'
        fill_in_form(state)
        click_button 'Update State'
      end

      it 'renders the index page' do
        expect(page).to have_current_path(admin_states_path, ignore_query: true)
      end

      it 'shows the new state name' do
        expect(page).to have_content(state.name)
      end
    end

    describe 'delete a state' do
      let!(:state_id) { state.id }

      before do
        visit admin_states_path

        click_link "delete_#{state.id}"
      end

      it 'renders index page' do
        expect(page).to have_current_path(admin_states_path, ignore_query: true)
      end

      it 'deletes the state' do
        expect(State.find_by(id: state_id)).to be_nil
      end
    end
  end

  def fill_in_form(state)
    fill_in 'Name', with: state.name
    fill_in 'Abbreviation', with: state.abbreviation
  end
end
