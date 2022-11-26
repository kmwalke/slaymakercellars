require 'rails_helper'

RSpec.describe 'Admin::Users' do
  describe 'logged out' do
    it 'must be logged in to manage users' do
      visit admin_users_path
      expect(page).to have_current_path(login_path, ignore_query: true)
    end

    it 'customers cannot view admin page' do
      login_as_customer
      visit admin_users_path
      expect(page).to have_current_path(customer_path, ignore_query: true)
    end
  end

  describe 'logged in' do
    let!(:user) { create(:admin) }

    before do
      login_as_admin
    end

    describe 'list users' do
      before do
        visit admin_users_path
      end

      it 'shows the user name' do
        expect(page.body).to include("\">#{user.name}</a>")
      end

      it 'shows the user email' do
        expect(page.body).to include("\">#{user.email}</a>")
      end

      it 'shows the user role' do
        expect(page.body).to include("\">#{user.role}</a>")
      end
    end

    describe 'create a user' do
      let(:user2) { build(:admin) }

      before do
        visit admin_users_path

        click_link 'New User'
        fill_in_form(user2)
        click_button 'Create User'
      end

      it 'renders the index' do
        expect(page).to have_current_path(admin_users_path, ignore_query: true)
      end

      it 'shows the new user' do
        expect(page.body).to include("\">#{user2.name}</a>")
      end
    end

    describe 'edit a user' do
      before do
        visit admin_users_path

        click_link user.name
        user.name = 'new name'
        fill_in_form(user)
        click_button 'Update User'
      end

      it 'renders the index' do
        expect(page).to have_current_path(admin_users_path, ignore_query: true)
      end

      it 'shows the edited user' do
        expect(page.body).to include("\">#{user.name}</a>")
      end
    end

    describe 'delete a user' do
      let(:user_id) { user.id }

      before do
        visit admin_users_path

        click_link "delete_#{user.id}"
      end

      it 'renders the index' do
        expect(page).to have_current_path(admin_users_path, ignore_query: true)
      end

      it 'does not show the deleted user' do
        expect(User.find_by(id: user_id)).to be_nil
      end
    end

    describe 'customer accounts' do
      let!(:contact) { create(:contact) }
      let!(:customer) { create(:customer, contact: nil) }

      it 'activates a customer account' do
        visit admin_users_path

        click_link customer.name
        select contact.name, from: 'Contact'
        click_button 'Update User'

        expect(customer.reload.contact_id).to eq(contact.id)
      end
    end
  end

  def fill_in_form(user)
    fill_in 'Name', with: user.name
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    select user.role, from: 'user_role'
  end
end
