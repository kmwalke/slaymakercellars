require 'rails_helper'

RSpec.describe Google::Maps do
  it 'builds a proper url' do
    contact    = create(:contact)
    proper_url = 'https://www.google.com/maps' \
                 "?q=#{contact.address}," \
                 "+#{contact.town.name}," \
                 "+#{contact.town.state.abbreviation}".gsub(' ', '+')

    expect(described_class.query_url(contact.full_address)).to eq(proper_url)
  end
end
