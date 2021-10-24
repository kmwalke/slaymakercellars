class CreateXeroSyncErrors < ActiveRecord::Migration[6.1]
  def change
    create_table :xero_sync_errors do |t|
      t.string :message
      t.references :syncable, polymorphic: true
      t.timestamps
    end
  end
end
