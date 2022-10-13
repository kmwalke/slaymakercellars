## This uses Google's URL Params Library.
# https://developers.google.com/maps/documentation/urls/get-started#directions-action

module Google
  class Directions < UrlParams
    GOOGLE_DIR_URL = 'https://www.google.com/maps/dir/?api=1'.freeze
    HOME           = '2036+Virginia+St,+Idaho+Springs,+CO'.freeze

    def self.get_directions_url(waypoints)
      raise Google::InvalidWaypointsError if waypoints.empty?

      api_string(waypoints)
    end

    private_class_method def self.api_string(waypoints)
      "#{GOOGLE_DIR_URL}&origin=#{HOME}&destination=#{HOME}#{waypoints_string(waypoints)}"
    end

    private_class_method def self.waypoints_string(waypoints)
      result = '&waypoints={'
      waypoints.each_with_index do |w, i|
        result += w
        result += '|' unless i == waypoints.length - 1
      end

      sanitize("#{result}}")
    end
  end
end
