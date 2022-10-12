module Google
  class InvalidWaypointsError < StandardError
    def message
      'You must use at least 2 valid waypoints.'
    end
  end
end
