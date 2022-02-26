require 'rails_helper'

RSpec.feature 'Customer::SignUp', type: :feature do
  describe 'sign up' do
    scenario 'displays sign up link' do
      visit login_path
      expect(page).to have_content('Sign Up')
    end

    scenario 'shows the sign up page' do
      visit login_path
      click_link('Sign Up')
      expect(current_path).to eq(signup_path)
      expect(page).to have_content('wholesale customer')
    end

    scenario 'signs up a new customer' do
      user = FactoryBot.build(:user)
      visit login_path
      click_link('Sign Up')
      fill_in 'Name', with: user.name
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      fill_in 'Password confirmation', with: user.password
      click_button 'Sign Up'

      expect(User.find_one_by(name: user.name).role).to eq(User::ROLES[:customer])
    end

    scenario 'shows an info page for unactivated customers' do
      # Users with customer role but no contact_id are unactivated.
      # Must be connected to a contact by an admin
      login_as(FactoryBot.create(:customer, contact: nil))
      expect(current_path).to eq(customer_path)
      expect(page).to have_content('has not been activated')
    end
  end
end
