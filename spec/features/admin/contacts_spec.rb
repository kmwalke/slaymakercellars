require 'rails_helper'

RSpec.feature 'Admin::Contacts', type: :feature do
  describe 'logged out' do
    scenario 'must be logged in to manage contacts' do
      visit admin_contacts_path
      expect(current_path).to eq(login_path)
    end
  end

  describe 'logged in' do
    let!(:town) { Town.create(name: 'town', state: State.create(name: 'name', abbreviation: 'AS')) }
    let!(:contact) { Contact.create(name: 'john', town: town) }
    let!(:deleted_contact) { Contact.create(name: 'deleted contact', town: town, deleted_at: DateTime.now) }

    before :each do
      login
    end

    scenario 'list contacts' do
      visit admin_contacts_path
      expect(page).to have_content(contact.name)
      expect(page).not_to have_content(deleted_contact.name)
    end

    scenario 'list deleted contacts' do
      visit admin_contacts_path
      click_link 'Deleted'
      expect(page).not_to have_content(contact.name)
      expect(page).to have_content(deleted_contact.name)
    end

    scenario 'create a contact' do
      contact2 = Contact.new(name: 'name2', town: town)
      visit admin_contacts_path

      click_link 'New Contact'
      fill_in_form(contact2)
      click_button 'Create Contact'

      expect(current_path).to eq(admin_contacts_path)
      expect(page).to have_content(contact2.name)
    end

    scenario 'edit a contact' do
      visit admin_contacts_path

      click_link contact.name
      contact.name = 'new name'
      fill_in_form(contact)
      click_button 'Update Contact'

      expect(current_path).to eq(admin_contacts_path)
      expect(page).to have_content(contact.name)
    end

    scenario 'soft delete a contact' do
      visit admin_contacts_path

      click_link "delete_#{contact.id}"
      expect(current_path).to eq(admin_contacts_path)
      expect(page).to have_content('archived')
    end

    scenario 'hard delete a contact' do
      visit admin_contacts_path
      click_link 'Deleted'

      click_link "delete_#{deleted_contact.id}"
      expect(current_path).to eq(admin_contacts_path)
      expect(page).to have_content('destroyed')
    end

    scenario 'undelete a contact' do
      visit edit_admin_contact_path(deleted_contact)
      click_link 'Activate Contact'

      expect(current_path).to eq(admin_contacts_path)
      expect(page).to have_content(contact.name)
    end

    describe 'notes' do
      scenario 'add a note' do
        visit edit_admin_contact_path(contact)
        click_link 'Add Note'

        fill_in 'Content', with: 'this is the content of the note'
        click_button 'Create Note'

        expect(current_path).to eq(edit_admin_contact_path(contact))
        expect(page).to have_content('this is the content of the note')

        expect(Note.last.created_by).to eq(current_user)
      end

      scenario 'resolve a note' do
        Note.create(content: 'note content', contact: contact, created_by: current_user)

        visit edit_admin_contact_path(contact)
        click_link 'Resolve Note'

        expect(current_path).to eq(edit_admin_contact_path(contact))
        expect(page).to have_content("Resolved by #{current_user.name}")
      end
    end
  end

  def fill_in_form(contact)
    fill_in 'Name', with: contact.name
    select contact.town.name, from: 'contact_town_id'
    fill_in 'Description', with: contact.description
  end
end
