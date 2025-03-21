require 'rails_helper'

RSpec.describe MenuSubSection, type: :model do
  it 'requires a name' do
    expect { create(:menu_sub_section, name: '') }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'requires a section' do
    expect(described_class.create(section_id: '').errors).to have_key(:section_id)
  end
end
