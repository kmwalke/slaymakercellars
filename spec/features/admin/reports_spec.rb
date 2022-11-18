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

        expect(current_path).to eq(admin_reports_kegs_path)
      end

      it 'shows the reg report calculated date' do
        visit admin_reports_kegs_path

        expect(page).to have_content(humanize_date(ReportInfo.keg_report_calculated_on))
      end

      it 'shows contacts with kegs' do
        contact = FactoryBot.create(:contact, num_kegs: 87_668_521)
        FactoryBot.create(:order, contact:, fulfilled_on: Date.yesterday)
        visit admin_reports_kegs_path

        expect(page).to have_content(contact.name)
        expect(page).to have_content(contact.num_kegs)
        expect(page).to have_content(humanize_date(contact.last_contacted))
      end

      it 'does not show contacts with no kegs' do
        contact = FactoryBot.create(:contact, num_kegs: 0)
        visit admin_reports_kegs_path

        expect(page).not_to have_content(contact.name)
      end
    end
  end
end
