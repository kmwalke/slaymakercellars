require 'rails_helper'

RSpec.feature 'Visit', type: :feature do
  scenario 'displays the visit page' do
    visit visit_path

    expect(page).to have_content('pop-up tasting room')
  end
end
