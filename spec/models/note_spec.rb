require 'rails_helper'

RSpec.describe Note do
  it 'requires a body' do
    expect { create(:note, body: '') }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'requires a contact' do
    expect { create(:note, contact_id: nil) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'is unresolved on creation' do
    note = create(:note)
    expect(note.resolved?).to be(false)
  end

  it 'is resolved' do
    note = create(:note, resolved_at: DateTime.now)
    expect(note.resolved?).to be(true)
  end
end
