require 'rails_helper'

RSpec.describe Admin::HomeController, type: :routing do
  it 'routes to #root' do
    expect(get: '/admin').to route_to('admin/home#index')
  end
end
