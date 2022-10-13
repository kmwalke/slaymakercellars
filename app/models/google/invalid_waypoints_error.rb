module Google
  class InvalidWaypointsError < StandardError
    def message
      'You must use at least 1 valid waypoint.'
    end
  end
end
