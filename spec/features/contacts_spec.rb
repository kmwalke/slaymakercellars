require 'rails_helper'

RSpec.feature 'Contacts', type: :feature do
  let!(:contact) { FactoryBot.create(:contact) }
  let!(:deleted_contact) { FactoryBot.create(:contact, deleted_at: DateTime.now) }

  scenario 'list contacts' do
    visit root_path
    click_link 'Where to Buy'
    expect(page).to have_content(contact.name)
    expect(page).not_to have_content(deleted_contact.name)
  end

  scenario 'do not list private contacts' do
    contact.update(is_public: false)
    visit root_path
    click_link 'Where to Buy'
    expect(page).not_to have_content(contact.name)
  end

  scenario 'list towns' do
    visit root_path
    click_link 'Where to Buy'
    expect(page).to have_content(contact.town.name).once
  end

  scenario 'do not list empty towns' do
    town = FactoryBot.create(:town)
    visit root_path
    click_link 'Where to Buy'
    expect(page).not_to have_content(town.name)
  end

  scenario 'do not list inactive towns' do
    contact.update(is_public: false)
    visit root_path
    click_link 'Where to Buy'
    expect(page).not_to have_content(contact.town.name)
  end
end
