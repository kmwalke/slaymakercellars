require 'rails_helper'

RSpec.describe MenuSection, type: :model do
  it 'requires a name' do
    expect { create(:menu_section, name: '') }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'calculates the position' do
    expect { true }.to be_nil
    # should put new sections at the end and should rearrange correctly
  end
end
