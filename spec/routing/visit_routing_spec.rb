require 'rails_helper'

RSpec.describe VisitController, type: :routing do
  it 'routes to #index' do
    expect(get: '/visit').to route_to('visit#index')
  end
end
