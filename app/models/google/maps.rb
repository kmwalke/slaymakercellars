## This uses Google's URL Params Library.
# https://developers.google.com/maps/documentation/urls/get-started#map-action

module Google
  class Maps < UrlParams
    GOOGLE_MAPS_BASE_URL  = 'https://www.google.com/maps?q='.freeze

    def self.get_map_url(contact)
      GOOGLE_MAPS_BASE_URL + address(contact)
    end

    private_class_method def self.address(contact)
      sanitize("#{contact.address}, #{contact.town.name}, #{contact.town.state.abbreviation}")
    end
  end
end
