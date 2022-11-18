require 'rails_helper'

RSpec.describe Customer::HomeController do
  it 'routes to #root' do
    expect(get: '/customer').to route_to('customer/home#index')
  end
end
