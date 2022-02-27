require 'rails_helper'

RSpec.describe Customer::SignupController, type: :routing do
  it 'routes to #signup' do
    expect(get: '/customer/signup').to route_to('customer/signup#new')
  end
end
