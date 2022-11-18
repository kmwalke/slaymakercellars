require 'rails_helper'

RSpec.describe Admin::HomeController do
  it 'routes to #root' do
    expect(get: '/admin').to route_to('admin/home#index')
  end
end
