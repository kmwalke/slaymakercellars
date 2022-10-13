## This uses Google's URL Params Library.
# https://developers.google.com/maps/documentation/urls/get-started#map-action

module Google
  class Maps < UrlParams
    GOOGLE_MAPS_BASE_URL = 'https://www.google.com/maps?q='.freeze

    def self.query_url(contact)
      GOOGLE_MAPS_BASE_URL + sanitize(contact.full_address)
    end
  end
end
