class User < ApplicationRecord
  has_secure_password

  belongs_to :contact, optional: true

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :role, presence: true
  validate :admin_cannot_have_contact

  ROLES = {
    admin: 'Admin',
    customer: 'Customer'
  }.freeze

  ROLE_NAMES = ROLES.values.freeze

  def xero_connected?
    !xeroUid.nil?
  end

  def customer_activated?
    !contact_id.nil?
  end

  private

  def admin_cannot_have_contact
    return unless role == ROLES[:admin] && !contact_id.nil?

    update(contact_id: nil)
    errors.add(:contact, 'cannot be added to admins.')
  end
end
