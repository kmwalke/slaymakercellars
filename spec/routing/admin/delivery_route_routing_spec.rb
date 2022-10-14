require 'rails_helper'

RSpec.describe Admin::DeliveryRouteController, type: :routing do
  it 'routes to #index' do
    expect(get: '/admin/delivery_route').to route_to('admin/delivery_route#index')
  end
end
