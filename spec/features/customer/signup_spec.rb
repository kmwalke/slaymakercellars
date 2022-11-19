require 'rails_helper'

RSpec.describe 'Customer::SignUp' do
  describe 'sign up' do
    it 'displays sign up link' do
      visit login_path
      expect(page).to have_content('sign up here')
    end

    describe 'shows the sign up page' do
      before do
        visit login_path
        click_link('sign up here')
      end

      it 'redirects to signup page' do
        expect(page).to have_current_path(customer_signup_path, ignore_query: true)
      end

      it 'renders signup page' do
        expect(page).to have_content('wholesale customer')
      end
    end

    describe 'signs up a new customer' do
      let(:user) { build(:user) }

      before do
        visit login_path
        click_link('sign up here')

        fill_in_form(user)
      end

      it 'sets customer role' do
        customer = User.find_sole_by(name: user.name)
        expect(customer.role).to eq(User::ROLES[:customer])
      end

      it 'sets customer contact_id to nil' do
        customer = User.find_sole_by(name: user.name)
        expect(customer.contact_id).to be_nil
      end
    end
  end

  private

  def fill_in_form(user)
    fill_in 'Name', with: user.name
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_button 'Sign Up'
  end
end
