require 'rails_helper'

RSpec.describe ProductsController do
  it 'routes to #index' do
    expect(get: '/products').to route_to('products#index')
  end
end
