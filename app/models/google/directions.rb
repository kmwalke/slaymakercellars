module Google
  class Directions
    GOOGLE_DIR_URL        = 'https://www.google.com/maps/dir/?api=1'.freeze
    UNKNOWN_ERROR_MESSAGE = 'An Unknown error has occurred. Have Kent check the logs.'.freeze
    HOME                  = '2036+Virginia+St,+Idaho+Springs,+CO'

    def self.get_directions_url(waypoints)
      raise Google::InvalidWaypointsError if waypoints.size < 2

      api_string(waypoints)
    end


    private

    def self.api_string(waypoints)
      "#{GOOGLE_DIR_URL}&origin=#{HOME}&destination=#{HOME}#{waypoints_string(waypoints)}&key=#{ENV.fetch('GOOGLE_API_KEY', nil)}"
    end

    def self.waypoints_string(waypoints)
      return if waypoints.length < 3

      result = '&waypoints=%7B'
      waypoints.each do |w|
        result += w.gsub(' ', '+')
        unless w == waypoints.last
          result += '%7C'
        end
      end

      "#{result}%7D"
    end
  end
end
