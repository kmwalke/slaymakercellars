require 'rails_helper'

RSpec.describe ContactsController do
  it 'routes to #index' do
    expect(get: '/contacts').to route_to('contacts#index')
  end
end
