require 'rails_helper'

RSpec.describe Google::Directions, type: :model do
  it 'should require at least 1 waypoint' do
    expect { Google::Directions.directions_url([]) }.to raise_error(Google::InvalidWaypointsError)
  end

  it 'builds a proper url' do
    waypoints  = ['one town', '2 street, anytown, ks', 'three', 'four, co']
    proper_url = 'https://www.google.com/maps/dir/?api=1' \
                 '&origin=2036+Virginia+St,+Idaho+Springs,+CO' \
                 '&destination=2036+Virginia+St,+Idaho+Springs,+CO' \
                 '&waypoints=%7Bone+town%7C2+street,+anytown,+ks%7Cthree%7Cfour,+co%7D'

    expect(Google::Directions.directions_url(waypoints)).to eq(proper_url)
  end
end
