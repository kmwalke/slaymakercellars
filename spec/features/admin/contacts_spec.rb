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
    let!(:current_user) { login_as_admin }

    describe 'list contacts' do
      before do
        visit admin_contacts_path
      end

      it 'shows an active contact' do
        expect(page.body).to include("\">#{contact.name}</a>")
      end

      it 'does not show a deleted contact' do
        expect(page.body).not_to include("\">#{deleted_contact.name}</a>")
      end
    end

    describe 'list deleted contacts' do
      before do
        visit admin_contacts_path
        click_link 'Deleted'
      end

      it 'does not show active contact' do
        expect(page.body).not_to include("\">#{contact.name}</a>")
      end

      it 'shows deleted contact' do
        expect(page.body).to include("\">#{deleted_contact.name}</a>")
      end
    end

    describe 'list urgent contacts' do
      let!(:urgent_contact) { create(:note).contact }

      before do
        visit admin_contacts_path
        click_link 'Urgent'
      end

      it 'does not show unurgent contact' do
        expect(page.body).not_to include("\">#{contact.name}</a>")
      end

      it 'shows urgent contact' do
        expect(page.body).to include("\">#{urgent_contact.name}</a>")
      end
    end

    describe 'create a contact' do
      let(:contact2) { build(:contact, town: create(:town)) }

      before do
        visit admin_contacts_path

        click_link 'New Contact'
        fill_in_form(contact2)
        click_button 'Create Contact'
      end

      it 'renders the index page' do
        expect(page).to have_current_path(admin_contacts_path, ignore_query: true)
      end

      it 'shows the contact name' do
        expect(page.body).to include("\">#{contact2.name}</a>")
      end
    end

    describe 'shows a contact' do
      before do
        contact.update(sales_rep: create(:sales_rep))

        visit admin_contacts_path
        click_link contact.name
      end
    end

    describe 'edit a contact' do
      before do
        visit admin_contacts_path

        click_link contact.name
        contact.name = 'new name'
        fill_in_form(contact)
        click_button 'Update Contact'
      end

      it 'renders the index page' do
        expect(page).to have_current_path(admin_contacts_path, ignore_query: true)
      end

      it 'shows the new contact name' do
        expect(page.body).to include("\">#{contact.name}</a>")
      end
    end

    describe 'soft delete a contact' do
      before do
        visit admin_contacts_path

        click_link "delete_#{contact.id}"
      end

      it 'renders the index page' do
        expect(page).to have_current_path(admin_contacts_path, ignore_query: true)
      end

      it 'displays the flash text' do
        expect(page).to have_content('archived')
      end

      it 'soft deletes the contact' do
        expect(contact.reload.deleted_at).not_to be_nil
      end
    end

    describe 'hard delete a contact' do
      before do
        visit admin_contacts_path
        click_link 'Deleted'

        click_link "delete_#{deleted_contact.id}"
      end

      it 'renders the index page' do
        expect(page).to have_current_path(admin_contacts_path, ignore_query: true)
      end

      it 'displays the flash text' do
        expect(page).to have_content('destroyed')
      end

      it 'hard deletes the contact' do
        expect { deleted_contact.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    describe 'undelete a contact' do
      before do
        visit edit_admin_contact_path(deleted_contact)
        click_link 'Activate Contact'
      end

      it 'renders the index page' do
        expect(page).to have_current_path(admin_contacts_path, ignore_query: true)
      end

      it 'shows the undeleted contact' do
        expect(page.body).to include("\">#{contact.name}</a>")
      end
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

    it 'repeats last order with the correct user' do
      create(:order, contact:, created_by: create(:admin))

      visit admin_contacts_path

      click_link contact.name
      click_link 'Repeat last order'
      expect(contact.orders.last.created_by).to eq(current_user)
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

      describe 'searches by name' do
        before do
          visit admin_contacts_path

          fill_in 'search', with: 'aa'
          click_button 'Search'
        end

        it 'shows filtered contact' do
          expect(page).to have_content(a_contact.name)
        end

        it 'does not show unfiltered contact' do
          expect(page).not_to have_content(b_contact.name)
        end
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
