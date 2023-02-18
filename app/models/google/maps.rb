## This uses Google's URL Params Library.
# https://developers.google.com/maps/documentation/urls/get-started#map-action

module Google
  class Maps < UrlParams
    GOOGLE_MAPS_BASE_URL = 'https://www.google.com/maps'.freeze

    def self.query_url(address)
      GOOGLE_MAPS_BASE_URL + '?q=' + sanitize(address)
    end

    def self.embed_url(address)
      "https://www.google.com/maps/embed/v1/place?key=#{@google_api_key}&q=#{sanitize(address)}"
    end
  end
end
