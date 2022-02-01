require 'rails_helper'

RSpec.feature 'Admin::Notes', type: :feature do
  let!(:contact) { FactoryBot.create(:contact) }
  let!(:note) { FactoryBot.create(:note, contact: contact) }

  before :each do
    login
  end

  it 'shows notes' do
    visit edit_admin_contact_path(contact)
    expect(page).to have_content(note.body)
    expect(page).not_to have_content('Resolved on ')
  end

  it 'creates notes' do
    body = 'Akira is completely overrated'
    visit edit_admin_contact_path(contact)
    click_link('Add Note')
    fill_in 'Body', with: body
    click_button 'Create Issue'

    expect(current_path).to eq(edit_admin_contact_path(contact))
    expect(page).to have_content(body)
  end

  it 'shows resolved notes' do
    note.update(resolved_at: DateTime.now)
    visit edit_admin_contact_path(contact)

    expect(page).to have_content('Resolved on ')
  end

  it 'shows the resolution of a note' do
    resolution = 'I guess it is fine if other people like Akira, I don\'t have to'
    visit edit_admin_contact_path(contact)
    click_link('Resolve')

    fill_in 'Resolution', with: resolution
    click_button 'Resolve Issue'

    expect(current_path).to eq(edit_admin_contact_path(contact))
    expect(page).to have_content(resolution)
  end
end
