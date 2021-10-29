module Xero
  module Syncable
    extend ActiveSupport::Concern

    has_many :xero_sync_errors, as: :syncable

    def synced?
      xero_id && xero_sync_errors.empty?
    end
  end
end
