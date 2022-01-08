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
  scope :urgent, -> { where(id: Note.where(resolved_at: nil).uniq.pluck(:contact_id)) }

  def self.display(show = 'active', search_string, order, direction)
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
      contacts.order(order || :name)
    end
  end

  def self.display_title(show)
    show == 'inactive' ? 'Deleted Contacts' : 'Active Contacts'
  end

  def self.search(search)
    search ? where('lower(name) LIKE lower(?)', "%#{search}%") : all
  end
end
