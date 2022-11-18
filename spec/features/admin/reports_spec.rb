require 'rails_helper'

describe 'Admin::Reports', type: :feature do
  describe 'logged out' do
    scenario 'must be logged in to view admin page' do
      visit admin_reports_path
      expect(current_path).to eq(login_path)
    end

    scenario 'customers cannot manage reports' do
      login_as_customer
      visit admin_reports_path
      expect(current_path).to eq(customer_path)
    end
  end

  describe 'logged in' do
    before(:each) do
      login_as_admin
    end

    it 'opens Admin::Reports' do
      visit admin_reports_path

      expect(current_path).to eq(admin_reports_path)
      expect(page).to have_content('Reports')
    end

    describe 'keg report' do
      it 'runs the keg report' do
        visit admin_reports_path

        first(:link, 'Keg Report').click

        expect(current_path).to eq(admin_keg_reports_path)
      end

      it 'shows contacts with kegs' do
        contact = FactoryBot.create(:contact, num_kegs: 21)
        visit admin_keg_reports_path

        expect(page).to have_content(contact.name)
        expect(page).to have_content(contact.num_kegs)
      end

      it 'does not show contacts with no kegs' do
        contact = FactoryBot.create(:contact, num_kegs: 0)
        visit admin_keg_reports_path

        expect(page).not_to have_content(contact.name)
        expect(page).not_to have_content(contact.num_kegs)
      end
    end
  end
end
