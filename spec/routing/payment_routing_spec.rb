require 'rails_helper'

RSpec.describe PaymentController, type: :routing do
  it 'routes to #index' do
    expect(get: '/payment').to route_to('payment#index')
  end
end
