require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  it 'requires a name' do
    expect { create(:menu_item, name: '') }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'requires a sub_section' do
    expect(described_class.create(sub_section_id: '').errors).to have_key(:sub_section_id)
  end
end
