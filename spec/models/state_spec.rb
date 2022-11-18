require 'rails_helper'

RSpec.describe State do
  it 'requires a name' do
    expect(described_class.create(name: '').errors).to have_key(:name)
  end

  it 'requires a abbreviation' do
    expect(described_class.create(abbreviation: '').errors).to have_key(:abbreviation)
  end
end
