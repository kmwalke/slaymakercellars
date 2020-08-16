require 'rails_helper'

RSpec.feature 'Contacts', type: :feature do
  let!(:town) { Town.create(name: 'town', state: State.create(name: 'name', abbreviation: 'AS')) }
  let!(:contact) { Contact.create(name: 'john', town: town) }
  let!(:deleted_contact) { Contact.create(name: 'deleted contact', town: town, deleted_at: DateTime.now) }

  scenario 'list contacts' do
    visit root_path
    click_link 'Where to Buy'
    expect(page).to have_content(contact.name)
    # expect(page).not_to have_content(deleted_contact.name)
  end
end
