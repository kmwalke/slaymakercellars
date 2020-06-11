require "rails_helper"

RSpec.feature 'Sessions', :type => :feature do
  before :each do
    login
  end

  scenario 'logs in' do
    visit root_path
    expect(page).to have_content('Log Out')
  end

  scenario 'logs out' do
    logout
    expect(page).to have_content('Log In')
  end
end