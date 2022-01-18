class Contact < ApplicationRecord
  include UrlValidator
  include SoftDeletable
  include Xero::Syncable

  belongs_to :town
  has_many :notes
  has_many :orders
  has_many :xero_sync_errors, as: :syncable

  validates :name, presence: true, uniqueness: true
  validates :town_id, presence: true

  validate :proper_url

  scope :active, -> { where(deleted_at: nil) }
  scope :inactive, -> { where.not(deleted_at: nil) }
  scope :urgent, -> { active.where(id: Note.where(resolved_at: nil).uniq.pluck(:contact_id)) }

  def self.display(show, search_string, order, direction)
    [show, display_contacts(show, search_string, order, direction), display_title(show)]
  end

  def unresolved_notes?
    notes.where('resolved_at is null').any?
  end

  def last_contacted
    notes.last.created_at
  end

  def town_name
    town&.name
  end

  def town_name=(name)
    self.town = Town.find_by(name: name)
  end

  def last_order
    order = orders.order('fulfilled_on desc').first

    order.fulfilled_on || Date.today if order
  end

  def repeat_last_order
    if orders.empty?
      new_order               = Order.new
      new_order.contact_id    = id
      new_order.delivery_date = Date.today
      new_order.save
    else
      order                   = orders.order('fulfilled_on desc').first
      new_order               = order.dup
      new_order.xero_id       = nil
      new_order.fulfilled_on  = nil
      new_order.delivery_date = Date.today
      new_order.save
      order.line_items.each do |item|
        new_order.line_items.create(item.dup.attributes)
      end

    end
    new_order
  end

  def self.display_contacts(show, search_string, order, direction)
    order_contacts(search_contacts(show, search_string), order, direction)
  end

  def self.search_contacts(show, search_string)
    case show
    when 'inactive'
      Contact.inactive.search(search_string)
    when 'urgent'
      Contact.urgent.search(search_string)
    else
      Contact.active.search(search_string)
    end
  end

  def self.order_contacts(contacts, order, direction)
    case order
    when 'town'
      contacts.joins(:town).order("towns.name #{direction}")
    else
      contacts.order("#{order} #{direction}")
    end
  end

  def self.display_title(show)
    show == 'inactive' ? 'Deleted Contacts' : 'Active Contacts'
  end

  def self.search(search)
    search ? where('lower(contacts.name) LIKE lower(?)', "%#{search}%") : all
  end
end
