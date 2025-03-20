require 'rails_helper'

RSpec.describe 'Contacts' do
  let!(:contact) { create(:contact, name: 'active contact') }
  let!(:deleted_contact) { create(:contact, name: 'deleted contact', deleted_at: DateTime.now) }

  it 'list contacts' do
    visit root_path
    click_link 'Where to Buy'
    expect(page).to have_content(contact.name)
  end

  it 'does not list deleted contacts' do
    visit root_path
    click_link 'Where to Buy'
    expect(page).to have_no_content(deleted_contact.name)
  end

  it 'do not list private contacts' do
    contact.update(is_public: false)
    visit root_path
    click_link 'Where to Buy'
    expect(page).to have_no_content(contact.name)
  end

  it 'list towns' do
    visit root_path
    click_link 'Where to Buy'
    expect(page).to have_content(contact.town.name).once
  end

  it 'do not list empty towns' do
    town = create(:town)
    visit root_path
    click_link 'Where to Buy'
    expect(page).to have_no_content(town.name)
  end

  it 'do not list inactive towns' do
    contact.update(is_public: false)
    visit root_path
    click_link 'Where to Buy'
    expect(page).to have_no_content(contact.town.name)
  end
end
