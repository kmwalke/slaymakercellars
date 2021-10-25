module Xero
  class NotConnectedError < StandardError
    def message
      'You must connect your user account to Xero.'
    end
  end
end
