require 'rails_helper'

RSpec.describe 'Admin::Contacts' do
  describe 'logged out' do
    it 'must be logged in to manage contacts' do
      visit admin_contacts_path
      expect(page).to have_current_path(login_path, ignore_query: true)
    end

    it 'customers cannot manage contacts' do
      login_as_customer
      visit admin_contacts_path
      expect(page).to have_current_path(customer_path, ignore_query: true)
    end
  end

  describe 'logged in' do
    let!(:contact) { create(:contact, name: 'Normal Contact') }
    let!(:deleted_contact) { create(:contact, deleted_at: DateTime.now) }

    before do
      login_as_admin
    end

    describe 'list contacts' do
      before do
        visit admin_contacts_path
      end

      it 'shows an active contact' do
        expect(page).to have_content(contact.name)
      end

      it 'does not show a deleted contact' do
        expect(page).not_to have_content(deleted_contact.name)
      end
    end

    it 'list deleted contacts' do
      visit admin_contacts_path
      click_link 'Deleted'
      expect(page).not_to have_content(contact.name)
      expect(page).to have_content(deleted_contact.name)
    end

    it 'list urgent contacts' do
      urgent_contact = create(:note).contact
      visit admin_contacts_path
      click_link 'Urgent'
      expect(page).not_to have_content(contact.name)
      expect(page).to have_content(urgent_contact.name)
    end

    it 'create a contact' do
      contact2 = build(:contact, town: create(:town))
      visit admin_contacts_path

      click_link 'New Contact'
      fill_in_form(contact2)
      click_button 'Create Contact'

      expect(page).to have_current_path(admin_contacts_path, ignore_query: true)
      expect(page).to have_content(contact2.name)
    end

    it 'edit a contact' do
      visit admin_contacts_path

      click_link contact.name
      contact.name = 'new name'
      fill_in_form(contact)
      click_button 'Update Contact'

      expect(page).to have_current_path(admin_contacts_path, ignore_query: true)
      expect(page).to have_content(contact.name)
    end

    it 'soft delete a contact' do
      visit admin_contacts_path

      click_link "delete_#{contact.id}"
      expect(page).to have_current_path(admin_contacts_path, ignore_query: true)
      expect(page).to have_content('archived')
    end

    it 'hard delete a contact' do
      visit admin_contacts_path
      click_link 'Deleted'

      click_link "delete_#{deleted_contact.id}"
      expect(page).to have_current_path(admin_contacts_path, ignore_query: true)
      expect(page).to have_content('destroyed')
    end

    it 'undelete a contact' do
      visit edit_admin_contact_path(deleted_contact)
      click_link 'Activate Contact'

      expect(page).to have_current_path(admin_contacts_path, ignore_query: true)
      expect(page).to have_content(contact.name)
    end

    it 'views all orders by a contact' do
      visit admin_contacts_path

      click_link contact.name
      click_link 'View all orders'

      expect(page).to have_current_path(admin_orders_path, ignore_query: true)
    end

    it 'repeats last order' do
      create(:order, contact:)

      visit admin_contacts_path

      click_link contact.name
      click_link 'Repeat last order'
      expect(page).to have_current_path(edit_admin_order_path(contact.orders.last), ignore_query: true)
    end

    it 'hides repeat option for new contacts' do
      visit admin_contacts_path

      click_link contact.name
      expect(page).not_to have_content('Repeat last order')
    end

    describe 'sorting & searching' do
      let!(:a_contact) { create(:contact, name: 'aaaa', town: create(:town, name: 'cccc')) }
      let!(:b_contact) { create(:contact, name: 'bbbb', town: create(:town, name: 'dddd')) }

      it 'sorts by name' do
        visit admin_contacts_path

        click_link 'Name'

        expect(page.body).to match(/aaaa.*bbbb/m)
      end

      it 'reverse sorts by name' do
        visit admin_contacts_path

        click_link 'Name'
        click_link 'Name'

        expect(page.body).to match(/bbbb.*aaaa/m)
      end

      it 'sorts by town' do
        visit admin_contacts_path

        click_link 'Town'

        expect(page.body).to match(/aaaa.*bbbb/m)
      end

      it 'reverse sorts by town' do
        visit admin_contacts_path

        click_link 'Town'
        click_link 'Town'

        expect(page.body).to match(/bbbb.*aaaa/m)
      end

      it 'searches by name' do
        visit admin_contacts_path

        fill_in 'search', with: 'aa'
        click_button 'Search'

        expect(page).to have_content(a_contact.name)
        expect(page).not_to have_content(b_contact.name)
      end
    end

    describe 'sync' do
      it 'shows xero sync errors' do
        message = 'bad email'
        contact.xero_sync_errors << XeroSyncError.new(message:)

        visit admin_contacts_path

        click_link contact.name
        expect(page).to have_content(message)
      end

      it 'does not show xero link for unsynced' do
        visit admin_contacts_path

        click_link contact.name
        expect(page).not_to have_content('View in Xero')
      end

      it 'shows xero link for synced' do
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
    fill_in 'Address', with: contact.address
  end
end
