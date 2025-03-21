require 'rails_helper'

RSpec.describe MenuSubSection, type: :model do
  it 'requires a name' do
    expect { create(:menu_sub_section, name: '') }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
