require 'rails_helper'

RSpec.describe Customer::HomeController, type: :routing do
  it 'routes to #root' do
    expect(get: '/customer').to route_to('customer/home#index')
  end
end
