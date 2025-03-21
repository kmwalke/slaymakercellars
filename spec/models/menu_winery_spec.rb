require 'rails_helper'

RSpec.describe MenuWinery, type: :model do
  it 'requires a name' do
    expect { create(:menu_winery, name: '') }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
