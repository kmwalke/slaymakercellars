require 'rails_helper'

RSpec.feature 'Payment', type: :feature do

  it 'shows the payment page' do
    visit payment

    expect(page).to have_content('Make a Payment')
  end
end
