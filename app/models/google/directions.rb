module Google
  class Directions
    GOOGLE_API_URL        = 'https://maps.googleapis.com/maps/api/directions/json?'.freeze
    UNKNOWN_ERROR_MESSAGE = 'An Unknown error has occurred. Have Kent check the logs.'.freeze

    attr_reader :id, :response, :errors

    def initialize(response, endpoint)
      @response = JSON.parse(response.body)
      @errors   = parse_errors(response)
      @id       = parse_id(endpoint)
    rescue StandardError
      Rails.logger.info("Google Response Status: #{response.status}")
      Rails.logger.info("Google Response: #{@response}")
      @errors = [{ 'Message' => UNKNOWN_ERROR_MESSAGE }]
    end

    def self.get_directions(waypoints)
      raise Google::InvalidWaypointsError if waypoints.size < 2

      response = JSON.parse(Faraday.get(api_string(waypoints)).body)
      return response unless response['status'] =='OK'
      response
    end


    private

    def self.parse_errors(response)
      return if response['error_message'].nil?
    end

    def self.api_string(waypoints)
      "#{GOOGLE_API_URL}origin=#{waypoints.first}&destination=#{waypoints.last}&key=#{ENV.fetch('GOOGLE_API_KEY', nil)}"
    end
  end
end
