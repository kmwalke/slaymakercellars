require 'rails_helper'

RSpec.describe State, type: :model do
  it 'should require a name' do
    expect(State.create(name: '').errors).to have_key(:name)
  end

  it 'should require a abbreviation' do
    expect(State.create(abbreviation: '').errors).to have_key(:abbreviation)
  end
end
