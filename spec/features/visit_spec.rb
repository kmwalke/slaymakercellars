require 'rails_helper'

RSpec.describe 'Visit' do
  it 'displays the visit page' do
    visit visit_path

    expect(page).to have_content('tasting room')
  end
end
