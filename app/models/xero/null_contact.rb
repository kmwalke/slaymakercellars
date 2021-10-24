module Xero
  class NullContact < Xero::BaseRecord
    attr_reader :id

    def initialize
      super(nil)
    end
  end
end
