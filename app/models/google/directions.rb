## This uses Google's URL Params Library.
# https://developers.google.com/maps/documentation/urls/get-started#directions-action

module Google
  class Directions
    GOOGLE_DIR_URL        = 'https://www.google.com/maps/dir/?api=1'.freeze
    HOME                  = '2036+Virginia+St,+Idaho+Springs,+CO'.freeze
    PIPE_CHAR             = '%7C'.freeze
    LEFT_CURL_BRACE_CHAR  = '%7B'.freeze
    RIGHT_CURL_BRACE_CHAR = '%7D'.freeze

    def self.get_directions_url(waypoints)
      raise Google::InvalidWaypointsError if waypoints.empty?

      api_string(waypoints)
    end

    private_class_method def self.api_string(waypoints)
      "#{GOOGLE_DIR_URL}&origin=#{HOME}&destination=#{HOME}#{waypoints_string(waypoints)}"
    end

    private_class_method def self.waypoints_string(waypoints)
      result = "&waypoints=#{LEFT_CURL_BRACE_CHAR}"
      waypoints.each_with_index do |w, i|
        result += w.gsub(' ', '+')
        result += PIPE_CHAR unless i == waypoints.length - 1
      end

      "#{result}#{RIGHT_CURL_BRACE_CHAR}"
    end
  end
end
