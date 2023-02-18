## This uses Google's URL Params Library.
# https://developers.google.com/maps/documentation/urls/get-started#map-action

module Google
  class Maps < UrlParams
    GOOGLE_MAPS_BASE_URL = 'https://www.google.com/maps'.freeze
    GOOGLE_API_KEY = ENV.fetch('GOOGLE_API_KEY').freeze

    def self.query_url(address)
      GOOGLE_MAPS_BASE_URL + '?q=' + sanitize(address)
    end

    def self.embed_url(address)
      "#{GOOGLE_MAPS_BASE_URL}/embed/v1/place?key=#{GOOGLE_API_KEY}" + '&q=' + sanitize(address)
    end
  end
end
