require 'rails_helper'

RSpec.describe Google::Maps do
  it 'builds a proper url' do
    contact = create(:contact)

    expect(described_class.query_url(contact.full_address)).to eq(proper_url(contact))
  end

  private

  def proper_url(contact)
    'https://www.google.com/maps' \
    "?q=#{contact.address}," \
    "+#{contact.town.name}," \
    "+#{contact.town.state.abbreviation}".gsub(' ', '+')
  end
end
