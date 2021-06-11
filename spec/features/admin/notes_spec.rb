require 'rails_helper'

RSpec.feature 'Admin::Notes', type: :feature do
  describe 'logged in' do
    let!(:town) { Town.create(name: 'town', state: State.create(name: 'name', abbreviation: 'AS')) }
    let!(:contact) { Contact.create(name: 'john', town: town) }
    let!(:contact_with_notes) { Contact.create(name: 'john1', town: town) }
    let!(:note1) { Note.create(body: 'this is note 1', contact: contact_with_notes) }
    let!(:note2) { Note.create(body: 'this is note 2', contact: contact_with_notes) }

    before :each do
      login
    end

    scenario 'lists notes' do
      visit admin_contacts_path
      click_link contact_with_notes.name

      expect(page).to have_content(note1.body)
      expect(page).to have_content(note2.body)

      expect(page).not_to have_content('Resolved by')
    end

    scenario 'resolve a note' do
      visit admin_contacts_path
      click_link contact_with_notes.name

      click_link 'Resolve'

      expect(page).to have_content('Resolved by')
    end

    scenario 'add a note' do
      visit admin_contacts_path

      click_link contact.name
      click_button 'Add Note'
      fill_in 'Body', with: 'this is a note'
      click_button 'Save Note'

      expect(current_path).to eq(admin_contact_path(contact))
      expect(page).to have_content('this is a note')
    end
  end
end
