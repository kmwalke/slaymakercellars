class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :role, presence: true

  ROLES = {
    admin: 'Admin',
    customer: 'Customer'
  }.freeze

  ROLE_NAMES = ROLES.values.freeze

  def xero_connected?
    !xeroUid.nil?
  end
end
