require 'rails_helper'

RSpec.describe Google::Maps, type: :model do
  it 'builds a proper url' do
    contact    = FactoryBot.create(:contact)
    proper_url = 'https://www.google.com/maps' \
                 "?q=#{contact.address}," \
                 "+#{contact.town.name}," \
                 "+#{contact.town.state.abbreviation}".gsub(' ', '+')

    expect(Google::Maps.query_url(contact)).to eq(proper_url)
  end
end
