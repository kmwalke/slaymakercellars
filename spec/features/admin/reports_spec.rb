require 'rails_helper'

describe 'Admin::Reports' do
  describe 'logged out' do
    it 'must be logged in to view admin page' do
      visit admin_reports_path
      expect(page).to have_current_path(login_path, ignore_query: true)
    end

    it 'customers cannot manage reports' do
      login_as_customer
      visit admin_reports_path
      expect(page).to have_current_path(customer_path, ignore_query: true)
    end
  end

  describe 'logged in' do
    before do
      login_as_admin
    end

    describe 'opens Admin::Reports' do
      before do
        visit admin_reports_path
      end

      it 'renders the reports page' do
        expect(page).to have_current_path(admin_reports_path, ignore_query: true)
      end

      it 'shows the title' do
        expect(page).to have_content('Reports')
      end
    end

    describe 'wholesale orders report' do
      it 'visits the report page' do
        visit admin_reports_path

        first(:link, 'Wholesale Orders Report').click

        expect(page).to have_current_path(admin_reports_orders_path, ignore_query: true)
      end

      describe 'report data' do
        before do
          visit admin_reports_orders_path
          fill_in 'Start Date', with: 8.days.ago
          fill_in 'End Date', with: 1.day.ago

          click_button 'Update'
        end

        it 'selects date for report' do
          expect(page).to have_current_path(admin_reports_orders_path, ignore_query: true)
        end

        it 'shows the proper data for a date range' do
          expect(true).to be(false)
        end

        it 'does not include data outside of date range' do
          expect(true).to be(false)
        end
      end
    end

    describe 'keg report', skip: 'hidden for now' do
      it 'runs the keg report' do
        visit admin_reports_path

        first(:link, 'Keg Report').click

        expect(page).to have_current_path(admin_reports_kegs_path, ignore_query: true)
      end

      it 'shows the reg report calculated date' do
        visit admin_reports_kegs_path

        expect(page).to have_content(humanize_date(ReportInfo.keg_report_calculated_on))
      end

      describe 'shows contacts with kegs' do
        let(:contact) { create(:contact, num_kegs: 87_668_521) }

        before do
          create(:order, contact:, fulfilled_on: Date.yesterday)
          visit admin_reports_kegs_path
        end

        it 'shows contact info' do
          expect(page.body).to include(
            "<td>#{contact.name}</td><td>#{contact.num_kegs}</td><td>#{humanize_date(contact.last_contacted)}</td>"
          )
        end
      end

      it 'does not show contacts with no kegs' do
        contact = create(:contact, num_kegs: 0)
        visit admin_reports_kegs_path

        expect(page).not_to have_content(contact.name)
      end
    end
  end
end
