require 'rails_helper'

RSpec.feature 'Customer::SignUp', type: :feature do
  describe 'sign up' do
    scenario 'displays sign up link' do
      visit login_path
      expect(page).to have_content('sign up here')
    end

    scenario 'shows the sign up page' do
      visit login_path
      click_link('sign up here')
      expect(current_path).to eq(customer_signup_path)
      expect(page).to have_content('wholesale customer')
    end

    scenario 'signs up a new customer' do
      user = FactoryBot.build(:user)
      visit login_path
      click_link('sign up here')
      fill_in 'Name', with: user.name
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      fill_in 'Password confirmation', with: user.password
      click_button 'Sign Up'

      customer = User.find_sole_by(name: user.name)
      expect(customer.role).to eq(User::ROLES[:customer])
      expect(customer.contact_id).to be_nil
    end

    scenario 'shows an info page for unactivated customers' do
      login_as(FactoryBot.create(:customer, contact: nil))
      expect(current_path).to eq(customer_path)
      expect(page).to have_content('has not been activated')
    end
  end
end
