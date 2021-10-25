module Xero
  class NullContact < Xero::BaseRecord
    attr_reader :id

    def initialize; end
  end
end
