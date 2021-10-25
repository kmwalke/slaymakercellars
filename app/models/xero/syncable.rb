module Xero
  module Syncable
    extend ActiveSupport::Concern

    def synced?
      xero_id && xero_sync_errors.empty?
    end
  end
end
