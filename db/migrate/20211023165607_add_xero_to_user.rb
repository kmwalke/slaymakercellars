class AddXeroToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :xeroUid, :string
    add_column :users, :xeroAccessToken, :string
    add_column :users, :xeroRefreshToken, :string
    add_column :users, :xeroTenantId, :string
    add_column :users, :xeroTokenExpiresAt, :string
    remove_column :users, :password_digest
  end
end
