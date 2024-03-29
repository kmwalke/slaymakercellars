class User < ApplicationRecord
  has_secure_password

  belongs_to :contact, optional: true

  has_many :orders

  validates :email, presence: true, uniqueness: true
  validates :name, presence: true
  validates :role, presence: true
  validate :admin_cannot_have_contact

  before_update :send_customer_activation_email
  after_commit :send_new_customer_emails

  scope :admins, -> { where(role: ROLES[:admin]) }
  scope :emailable_admins, -> { where(role: ROLES[:admin], receives_emails: true) }

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

  def send_customer_activation_email
    return unless contact_id_changed?

    CustomerMailer.with(user: self).account_activated.deliver_later
  end

  def send_new_customer_emails
    return unless role == ROLES[:customer]

    CustomerMailer.with(user: self).welcome.deliver_later
    CustomerMailer.with(user: self).new_customer.deliver_later
  end
end
