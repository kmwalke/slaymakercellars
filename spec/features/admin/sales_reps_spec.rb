require 'rails_helper'

RSpec.describe 'Admin::Sales_Reps' do
  describe 'logged out' do
    it 'must be logged in to manage sales reps' do
      visit admin_sales_reps_path
      expect(page).to have_current_path(login_path, ignore_query: true)
    end

    it 'customers cannot view admin page' do
      login_as_customer
      visit admin_sales_reps_path
      expect(page).to have_current_path(customer_path, ignore_query: true)
    end
  end

  describe 'logged in' do
    let!(:sales_rep) { create(:sales_rep) }

    before do
      login_as_admin
    end

    it 'list sales reps' do
      visit admin_sales_reps_path
      expect(page.body).to include("\">#{sales_rep.name}</a>")
    end

    it 'list sales reps email' do
      visit admin_sales_reps_path
      expect(page.body).to include(sales_rep.email)
    end

    describe 'shows sales rep' do
      before do
        3.times do
          create(:contact, sales_rep: sales_rep)
        end

        visit admin_sales_reps_path
        click_link sales_rep.name
      end

      it 'shows a sales rep' do
        expect(page.body).to include(sales_rep.name)
      end

      it 'shows sales reps contacts' do
        sales_rep.contacts.each do |contact|
          expect(page.body).to include(contact.name)
        end
      end
    end

    describe 'create a sales rep' do
      let!(:sales_rep2) { build(:sales_rep) }

      before do
        visit admin_sales_reps_path

        click_link 'New Sales Rep'
        fill_in_form(sales_rep2)
        click_button 'Create Sales rep'
      end

      it 'renders the index page' do
        expect(page).to have_current_path(admin_sales_reps_path, ignore_query: true)
      end

      it 'shows a sales rep' do
        expect(page.body).to include("\">#{sales_rep2.name}</a>")
      end
    end

    describe 'edit a sales rep' do
      before do
        visit admin_sales_reps_path

        click_link sales_rep.name
        sales_rep.name = 'new name'
        fill_in_form(sales_rep)
        click_button 'Update Sales rep'
      end

      it 'renders the index page' do
        expect(page).to have_current_path(admin_sales_reps_path, ignore_query: true)
      end

      it 'shows the new name' do
        expect(page.body).to include("\">#{sales_rep.name}</a>")
      end
    end

    describe 'delete a sales rep' do
      let!(:sales_rep_id) { sales_rep.id }

      before do
        visit admin_sales_reps_path

        click_link "delete_#{sales_rep.id}"
      end

      it 'renders the index page' do
        expect(page).to have_current_path(admin_sales_reps_path, ignore_query: true)
      end

      it 'removes the sales rep' do
        expect(SalesRep.find_by(id: sales_rep_id)).to be_nil
      end
    end
  end

  def fill_in_form(sales_rep)
    fill_in 'Name', with: sales_rep.name
    fill_in 'Email', with: sales_rep.email
  end
end
