require 'rails_helper'

RSpec.describe 'Sessions' do
  it 'redirects to requested admin page' do
    visit admin_users_path
    expect(page).to have_current_path(login_path, ignore_query: true)
    login_as_admin
    expect(page).to have_current_path(admin_users_path, ignore_query: true)
  end

  describe 'logged in' do
    before do
      login_as_admin
    end

    it 'logs in' do
      expect(page).to have_content('Log Out')
      expect(page).to have_current_path('/admin')
    end

    it 'logs out' do
      logout
      expect(page).not_to have_content('Log Out')
      expect(page).to have_current_path(root_path, ignore_query: true)
    end
  end
end
