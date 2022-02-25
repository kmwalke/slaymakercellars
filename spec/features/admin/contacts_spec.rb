require 'rails_helper'

RSpec.feature 'Admin::Contacts', type: :feature do
  describe 'logged out' do
    scenario 'must be logged in to manage contacts' do
      visit admin_contacts_path
      expect(current_path).to eq(login_path)
    end

    scenario 'customers cannot manage contacts' do
      login_as_customer
      visit admin_contacts_path
      expect(current_path).to eq(login_path)
    end
  end

  describe 'logged in' do
    let!(:contact) { FactoryBot.create(:contact) }
    let!(:deleted_contact) { FactoryBot.create(:contact, deleted_at: DateTime.now) }

    before :each do
      login_as_admin
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

    scenario 'list urgent contacts' do
      urgent_contact = FactoryBot.create(:note).contact
      visit admin_contacts_path
      click_link 'Urgent'
      expect(page).not_to have_content(contact.name)
      expect(page).to have_content(urgent_contact.name)
    end

    scenario 'create a contact' do
      contact2 = FactoryBot.build(:contact, town: FactoryBot.create(:town))
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

    scenario 'views all orders by a contact' do
      visit admin_contacts_path

      click_link contact.name
      click_link 'View all orders'

      expect(current_path).to eq(admin_orders_path)
    end

    scenario 'it repeats last order' do
      FactoryBot.create(:order, contact: contact)

      visit admin_contacts_path

      click_link contact.name
      click_link 'Repeat last order'
      expect(current_path).to eq(edit_admin_order_path(contact.orders.last))
    end

    scenario 'it hides repeat option for new contacts' do
      visit admin_contacts_path

      click_link contact.name
      expect(page).not_to have_content('Repeat last order')
    end

    describe 'sorting & searching' do
      let!(:a_contact) { FactoryBot.create(:contact, name: 'aaaa', town: FactoryBot.create(:town, name: 'cccc')) }
      let!(:b_contact) { FactoryBot.create(:contact, name: 'bbbb', town: FactoryBot.create(:town, name: 'dddd')) }

      scenario 'sorts by name' do
        visit admin_contacts_path

        click_link 'Name'

        expect(page.body).to match(/aaaa.*bbbb/m)
      end

      scenario 'reverse sorts by name' do
        visit admin_contacts_path

        click_link 'Name'
        click_link 'Name'

        expect(page.body).to match(/bbbb.*aaaa/m)
      end

      scenario 'sorts by town' do
        visit admin_contacts_path

        click_link 'Town'

        expect(page.body).to match(/aaaa.*bbbb/m)
      end

      scenario 'reverse sorts by town' do
        visit admin_contacts_path

        click_link 'Town'
        click_link 'Town'

        expect(page.body).to match(/bbbb.*aaaa/m)
      end

      scenario 'searches by name' do
        visit admin_contacts_path

        fill_in 'search', with: 'aa'
        click_button 'Search'

        expect(page).to have_content(a_contact.name)
        expect(page).not_to have_content(b_contact.name)
      end
    end

    describe 'sync' do
      scenario 'shows xero sync errors' do
        message = 'bad email'
        contact.xero_sync_errors << XeroSyncError.new(message: message)

        visit admin_contacts_path

        click_link contact.name
        expect(page).to have_content(message)
      end

      scenario 'does not show xero link for unsynced' do
        visit admin_contacts_path

        click_link contact.name
        expect(page).not_to have_content('View in Xero')
      end

      scenario 'shows xero link for synced' do
        contact.update(xero_id: 'abc123')
        visit admin_contacts_path

        click_link contact.name
        expect(page).to have_content('View in Xero')
      end
    end
  end

  def fill_in_form(contact)
    fill_in 'Name', with: contact.name
    fill_in 'Town', with: contact.town.name
    fill_in 'Description', with: contact.description
  end
end
