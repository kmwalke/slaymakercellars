require 'rails_helper'

RSpec.describe 'Menu' do
  it 'displays the menu page' do
    visit menu_path

    expect(page).to have_content('Guest Mead')
  end
end
