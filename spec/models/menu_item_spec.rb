require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  it 'requires a name' do
    expect { create(:menu_item, name: '') }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
