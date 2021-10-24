class XeroSyncError < ApplicationRecord
  belongs_to :syncable, polymorphic: true
end
