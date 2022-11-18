require 'rails_helper'

RSpec.describe 'Customer::SignUp' do
  describe 'sign up' do
    it 'displays sign up link' do
      visit login_path
      expect(page).to have_content('sign up here')
    end

    it 'shows the sign up page' do
      visit login_path
      click_link('sign up here')
      expect(page).to have_current_path(customer_signup_path, ignore_query: true)
      expect(page).to have_content('wholesale customer')
    end

    it 'signs up a new customer' do
      user = build(:user)
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
  end
end
