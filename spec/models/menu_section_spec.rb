require 'rails_helper'

RSpec.describe MenuSection, type: :model do
  it 'requires a name' do
    expect { create(:menu_section, name: '') }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
