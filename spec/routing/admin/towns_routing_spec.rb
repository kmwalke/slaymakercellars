require 'rails_helper'

RSpec.describe Admin::TownsController, type: :routing do
  it 'routes to #index' do
    expect(get: '/admin/towns').to route_to('admin/towns#index')
  end

  it 'routes to #new' do
    expect(get: '/admin/towns/new').to route_to('admin/towns#new')
  end

  it 'routes to #edit' do
    expect(get: '/admin/towns/1/edit').to route_to('admin/towns#edit', id: '1')
  end

  it 'routes to #create' do
    expect(post: '/admin/towns').to route_to('admin/towns#create')
  end

  it 'routes to #update via PUT' do
    expect(put: '/admin/towns/1').to route_to('admin/towns#update', id: '1')
  end

  it 'routes to #update via PATCH' do
    expect(patch: '/admin/towns/1').to route_to('admin/towns#update', id: '1')
  end

  it 'routes to #destroy' do
    expect(delete: '/admin/towns/1').to route_to('admin/towns#destroy', id: '1')
  end
end
