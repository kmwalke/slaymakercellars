require 'rails_helper'

RSpec.describe Note, type: :model do
  it 'should require a body' do
    expect { FactoryBot.create(:note, body: '') }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should require a contact' do
    expect { FactoryBot.create(:note, contact_id: nil) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should be unresolved on creation' do
    note = FactoryBot.create(:note)
    expect(note.resolved?).to eq(false)
  end

  it 'should be resolved' do
    note = FactoryBot.create(:note, resolved_at: DateTime.now)
    expect(note.resolved?).to eq(true)
  end
end
