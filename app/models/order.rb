class Order < ApplicationRecord
  include SoftDeletable

  has_many :line_items, inverse_of: :order
  belongs_to :contact
  belongs_to :created_by, class_name: 'User'
  belongs_to :updated_by, class_name: 'User', optional: true
  accepts_nested_attributes_for :line_items, allow_destroy: true

  validates :contact_id, presence: true
  validates :delivery_date, presence: true

  scope :late, lambda {
    where('fulfilled_on is null and delivery_date < ?', Date.today).order('delivery_date asc')
  }

  scope :fulfilled, -> { where.not(fulfilled_on: nil).order('fulfilled_on DESC') }
  scope :active, -> { where(fulfilled_on: nil, deleted_at: nil).order('delivery_date asc') }
  scope :inactive, -> { where.not(deleted_at: nil) }

  def self.to_be_fulfilled(day)
    if day == Date.today
      Order.where('fulfilled_on is NULL AND delivery_date <= ?', Date.today)
    else
      Order.where(fulfilled_on: nil, delivery_date: day)
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

  def fulfilled?
    fulfilled_on != nil
  end

  def fulfill
    update(fulfilled_on: Date.today)
  end

  def unfulfill
    self.fulfilled_on = nil
  end
end
