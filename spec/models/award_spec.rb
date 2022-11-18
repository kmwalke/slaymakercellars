require 'rails_helper'

RSpec.describe Award do
  it 'requires a name' do
    expect { create(:award, name: '') }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'requires a product' do
    expect { create(:award, product: nil) }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
