class VisitController < ApplicationController
  def index
    @google_api_key = ENV.fetch('GOOGLE_API_KEY').freeze
  end
end
