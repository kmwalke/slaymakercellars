require 'rails_helper'

RSpec.describe Admin::SalesRepsController do
  it 'routes to #index' do
    expect(get: '/admin/sales_reps').to route_to('admin/sales_reps#index')
  end

  it 'routes to #new' do
    expect(get: '/admin/sales_reps/new').to route_to('admin/sales_reps#new')
  end

  it 'routes to #edit' do
    expect(get: '/admin/sales_reps/1/edit').to route_to('admin/sales_reps#edit', id: '1')
  end

  it 'routes to #create' do
    expect(post: '/admin/sales_reps').to route_to('admin/sales_reps#create')
  end

  it 'routes to #update via PUT' do
    expect(put: '/admin/sales_reps/1').to route_to('admin/sales_reps#update', id: '1')
  end

  it 'routes to #update via PATCH' do
    expect(patch: '/admin/sales_reps/1').to route_to('admin/sales_reps#update', id: '1')
  end

  it 'routes to #destroy' do
    expect(delete: '/admin/sales_reps/1').to route_to('admin/sales_reps#destroy', id: '1')
  end
end
