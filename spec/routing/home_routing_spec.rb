require 'rails_helper'

RSpec.describe HomeController do
  it 'routes to #root' do
    expect(get: root_path).to route_to('home#index')
  end
end
