## This uses Google's URL Params Library.
# https://developers.google.com/maps/documentation/urls/get-started#map-action

module Google
  class Maps
    GOOGLE_MAPS_BASE_URL  = 'https://www.google.com/maps?q='.freeze

    def self.get_map_url(address)
      GOOGLE_MAPS_BASE_URL + address.gsub(' ', '+')
    end
  end
end
