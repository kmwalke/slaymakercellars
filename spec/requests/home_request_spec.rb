require 'rails_helper'

RSpec.describe 'Home', type: :request do
  it 'renders the homepage' do
    get root_path
    expect(response).to render_template(:index)
  end

  it 'has the proper content on homepage' do
    get root_path
    expect(response.body).to include('Kenobi')
  end
end
