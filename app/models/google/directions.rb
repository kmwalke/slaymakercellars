module Google
  class Directions
    GOOGLE_DIR_URL        = 'https://www.google.com/maps/dir/?api=1'.freeze
    UNKNOWN_ERROR_MESSAGE = 'An Unknown error has occurred. Have Kent check the logs.'.freeze
    HOME                  = '2036+Virginia+St,+Idaho+Springs,+CO'.freeze
    PIPE_CHAR             = '%7C'.freeze
    LEFT_CURL_BRACE_CHAR  = '%7B'.freeze
    RIGHT_CURL_BRACE_CHAR = '%7D'.freeze

    def self.get_directions_url(waypoints)
      raise Google::InvalidWaypointsError if waypoints.empty?

      api_string(waypoints)
    end

    def self.api_string(waypoints)
      "#{GOOGLE_DIR_URL}&origin=#{HOME}&destination=#{HOME}#{waypoints_string(waypoints)}"
    end

    def self.waypoints_string(waypoints)
      result = "&waypoints=#{LEFT_CURL_BRACE_CHAR}"
      waypoints.each do |w|
        result += w.gsub(' ', '+')
        result += PIPE_CHAR unless w == waypoints.last
      end

      "#{result}#{RIGHT_CURL_BRACE_CHAR}"
    end
  end
end
