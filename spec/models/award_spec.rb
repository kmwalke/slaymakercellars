require 'rails_helper'

RSpec.describe Award, type: :model do
  it 'should require a name' do
    expect { FactoryBot.create(:award, name: '') }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should require a product' do
    expect { FactoryBot.create(:award, product: nil) }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
