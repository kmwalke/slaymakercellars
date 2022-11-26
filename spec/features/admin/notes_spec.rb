require 'rails_helper'

RSpec.describe 'Admin::Notes' do
  let!(:contact) { create(:contact) }
  let!(:note) { create(:note, contact:) }

  before do
    login_as_admin
  end

  describe 'shows notes' do
    before do
      visit edit_admin_contact_path(contact)
    end

    it 'shows note body' do
      expect(page).to have_content(note.body)
    end

    it 'shows note resolved date' do
      expect(page).not_to have_content('Resolved on ')
    end
  end

  describe 'creates notes' do
    let(:body) { 'Akira is completely overrated' }

    before do
      visit edit_admin_contact_path(contact)
      click_link('Add Note')
      fill_in 'Body', with: body
      click_button 'Create Issue'
    end

    it 'renders the edit contact page' do
      expect(page).to have_current_path(edit_admin_contact_path(contact), ignore_query: true)
    end

    it 'shows note body' do
      expect(page).to have_content(body)
    end
  end

  it 'shows resolved notes' do
    note.update(resolved_at: DateTime.now)
    visit edit_admin_contact_path(contact)

    expect(page).to have_content('Resolved on ')
  end

  describe 'shows the resolution of a note' do
    let(:resolution) { 'I guess it is fine if other people like Akira, I don\'t have to' }

    before do
      visit edit_admin_contact_path(contact)
      click_link('Resolve')

      fill_in 'Resolution', with: resolution
      click_button 'Resolve Issue'
    end

    it 'renders edit contact page' do
      expect(page).to have_current_path(edit_admin_contact_path(contact), ignore_query: true)
    end

    it 'shows resolution' do
      expect(page).to have_content(resolution)
    end
  end
end
