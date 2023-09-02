class Contact < ApplicationRecord
  include UrlValidator
  include SoftDeletable
  include Xero::Syncable

  belongs_to :town
  has_many :notes
  has_many :orders
  has_many :xero_sync_errors, as: :syncable
  has_one :user

  validates :name, presence: true, uniqueness: true
  validates :address, presence: true
  validates :town_id, presence: true
  validates :num_kegs, numericality: { greater_than_or_equal_to: 0 }

  validate :proper_url

  scope :active, -> { where(deleted_at: nil) }
  scope :inactive, -> { where.not(deleted_at: nil) }
  scope :urgent, -> { active.where(id: Note.where(resolved_at: nil).pluck(:contact_id).uniq) }

  def self.display(show, search_string, order, direction)
    [show, display_contacts(show, search_string, order, direction), display_title(show)]
  end

  def unresolved_notes?
    notes.where(resolved_at: nil).any?
  end

  def last_contacted
    return last_order_date if last_note_date.nil?
    return last_note_date if last_order_date.nil?

    [last_note_date, last_order_date].max
  end

  def town_name
    town&.name
  end

  def town_name=(name)
    self.town = Town.find_by(name:)
  end

  def full_address
    "#{address}, #{town.name}, #{town.state.abbreviation}"
  end

  def last_fulfilled_order_date
    order = orders.order('fulfilled_on desc').first

    order.fulfilled_on || Time.zone.today if order
  end

  def repeat_last_order
    return if orders.empty?
    order                  = orders.order('fulfilled_on desc').first
    new_order               = order.dup
    new_order.xero_id       = nil
    new_order.fulfilled_on  = nil
    new_order.delivery_date = Time.zone.today
    new_order.updated_by    = nil
    new_order.save
    order.line_items.each do |item|
      new_order.line_items.create(item.dup.attributes)
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

  private

  def last_note_date
    notes.last&.created_at&.to_date
  end

  def last_order_date
    orders.last&.fulfilled_on || orders.last&.created_at&.to_date
  end
end
