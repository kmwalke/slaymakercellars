class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :role, presence: true

  ROLES = {
    admin: 'Admin',
    customer: 'Customer'
  }

  def xero_connected?
    !xeroUid.nil?
  end
end
