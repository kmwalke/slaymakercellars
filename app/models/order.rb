class Order < ApplicationRecord
  include SoftDeletable
  include Xero::Syncable

  has_many :line_items, inverse_of: :order
  has_many :xero_sync_errors, as: :syncable
  belongs_to :contact
  belongs_to :created_by, class_name: 'User'
  belongs_to :updated_by, class_name: 'User', optional: true
  belongs_to :assigned_to, class_name: 'User', optional: true
  accepts_nested_attributes_for :line_items, allow_destroy: true

  validates :contact_id, presence: true
  validates :delivery_date, presence: true

  after_commit :send_assigned_order_email

  scope :active, -> { where(fulfilled_on: nil, deleted_at: nil).order('delivery_date asc') }
  scope :fulfilled, -> { where.not(fulfilled_on: nil).order('fulfilled_on DESC') }
  scope :inactive, -> { where.not(deleted_at: nil) }
  scope :late, -> { active.where('delivery_date < ?', Date.today).order('delivery_date asc') }

  def self.to_be_fulfilled(day)
    if day == Date.today
      Order.active.where('delivery_date <= ?', Date.today)
    else
      Order.active.where(delivery_date: day)
    end
  end

  def self.display_all(show)
    display(Order.all, show)
  end

  def self.display(orders, show)
    case show
    when 'late'
      [orders.late, 'Late Orders']
    when 'fulfilled'
      [orders.fulfilled, 'Delivered Orders']
    when 'active'
      [orders.active, 'Active Orders']
    when 'void'
      [orders.inactive, 'Void Orders']
    else
      contact = Contact.find_by_id(show)
      [contact.orders.order('delivery_date DESC'), "Orders by #{contact.name}"]
    end
  end

  def contact_name
    contact&.name
  end

  def contact_name=(name)
    self.contact = Contact.find_by(name:)
  end

  def fulfilled?
    fulfilled_on != nil
  end

  def fulfill
    update(fulfilled_on: Date.today)
  end

  def unfulfill
    update(fulfilled_on: nil)
  end

  private

  def send_assigned_order_email
    return if assigned_to.nil?

    OrderMailer.with(order: self).assigned.deliver_later
  end
end
