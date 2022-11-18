require 'rails_helper'

RSpec.describe Admin::FulfillmentController do
  it 'routes to #index' do
    expect(get: '/admin/fulfillment').to route_to('admin/fulfillment#index')
  end
end
