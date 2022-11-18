require 'rails_helper'

RSpec.describe Google::Directions do
  it 'requires at least 1 waypoint' do
    expect { described_class.query_url([]) }.to raise_error(Google::InvalidWaypointsError)
  end

  it 'builds a proper url' do
    waypoints = ['one town', '2 street, anytown, ks', 'three', 'four, co']

    expect(described_class.query_url(waypoints)).to eq(proper_url)
  end

  private

  def proper_url
    'https://www.google.com/maps/dir/?api=1' \
      '&origin=2036+Virginia+St,+Idaho+Springs,+CO' \
      '&destination=2036+Virginia+St,+Idaho+Springs,+CO' \
      '&waypoints=%7Bone+town%7C2+street,+anytown,+ks%7Cthree%7Cfour,+co%7D'
  end
end
