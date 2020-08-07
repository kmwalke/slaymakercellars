require 'rails_helper'

RSpec.describe Admin::StatesController, type: :routing do
  it 'routes to #index' do
    expect(get: '/admin/states').to route_to('admin/states#index')
  end

  it 'routes to #new' do
    expect(get: '/admin/states/new').to route_to('admin/states#new')
  end

  it 'routes to #edit' do
    expect(get: '/admin/states/1/edit').to route_to('admin/states#edit', id: '1')
  end

  it 'routes to #create' do
    expect(post: '/admin/states').to route_to('admin/states#create')
  end

  it 'routes to #update via PUT' do
    expect(put: '/admin/states/1').to route_to('admin/states#update', id: '1')
  end

  it 'routes to #update via PATCH' do
    expect(patch: '/admin/states/1').to route_to('admin/states#update', id: '1')
  end

  it 'routes to #destroy' do
    expect(delete: '/admin/states/1').to route_to('admin/states#destroy', id: '1')
  end
end
