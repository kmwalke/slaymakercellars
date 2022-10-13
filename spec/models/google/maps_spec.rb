require 'rails_helper'

RSpec.describe Google::Maps, type: :model do

  it 'builds a proper url' do
    address    = '1535 Miner St, Idaho Springs, CO'
    proper_url = 'https://www.google.com/maps?q=1535+Miner+St,+Idaho+Springs,+CO'

    expect(Google::Maps.get_map_url(address)).to eq(proper_url)
  end
end
