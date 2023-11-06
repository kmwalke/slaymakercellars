require 'rails_helper'

RSpec.describe MenuController do
  it 'routes to #index' do
    expect(get: '/menu').to route_to('menu#index')
  end
end
