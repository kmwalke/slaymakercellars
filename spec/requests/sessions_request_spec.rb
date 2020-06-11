require 'rails_helper'

RSpec.describe 'Sessions', type: :request do

  describe 'GET /create' do
    it 'returns http success' do
      get '/login'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /destroy' do
    xit 'returns http success' do
      get '/logout'
      expect(response).to have_http_status(:success)
    end
  end
end
