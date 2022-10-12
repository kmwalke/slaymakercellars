require 'rails_helper'

RSpec.describe Google::Directions, type: :model do
  it 'should require at least 2 waypoints' do
    expect { Google::Directions.get_directions_url(['']) }.to raise_error(Google::InvalidWaypointsError)
  end
end
