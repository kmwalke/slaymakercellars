require 'rails_helper'

RSpec.describe Admin::ReportsController, type: :routing do
  it 'routes to #index' do
    expect(get: '/admin/reports').to route_to('admin/reports#index')
  end
end
