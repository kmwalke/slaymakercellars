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

    it 'list users' do
      visit admin_users_path
      expect(page).to have_content(user.name)
      expect(page).to have_content(user.email)
      expect(page).to have_content(user.role)
    end

    it 'create a user' do
      user2 = build(:admin)
      visit admin_users_path

      click_link 'New User'
      fill_in_form(user2)
      click_button 'Create User'

      expect(page).to have_current_path(admin_users_path, ignore_query: true)
      expect(page).to have_content(user2.name)
    end

    it 'edit a user' do
      visit admin_users_path

      click_link user.name
      user.name = 'new name'
      fill_in_form(user)
      click_button 'Update User'

      expect(page).to have_current_path(admin_users_path, ignore_query: true)
      expect(page).to have_content(user.name)
    end

    it 'delete a user' do
      user_id = user.id
      visit admin_users_path

      click_link "delete_#{user.id}"
      expect(page).to have_current_path(admin_users_path, ignore_query: true)
      expect(User.find_by(id: user_id)).to be_nil
    end

    it 'activates a customer account' do
      contact  = create(:contact)
      customer = create(:customer, contact: nil)
      visit admin_users_path

      click_link customer.name
      select contact.name, from: 'Contact'
      click_button 'Update User'

      expect(customer.reload.contact_id).to eq(contact.id)
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
