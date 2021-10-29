class Contact < ApplicationRecord
  include UrlValidator
  include SoftDeletable
  include Xero::Syncable

  belongs_to :town
  has_many :notes
  has_many :orders

  validates :name, presence: true, uniqueness: true
  validates :town_id, presence: true

  validate :proper_url

  scope :active, -> { where(deleted_at: nil) }
  scope :inactive, -> { where.not(deleted_at: nil) }
  scope :urgent, -> { where(id: Note.where(resolved_at: nil).uniq.pluck(:contact_id)) }

  def self.display(show = 'active', search_string = nil, order = :name)
    [show, display_contacts(show, search_string).order(order), display_title(show)]
  end

  def unresolved_notes?
    notes.where('resolved_at is null').any?
  end

  def self.display_contacts(show, search_string)
    case show
    when 'inactive'
      Contact.inactive.search(search_string)
    when 'urgent'
      Contact.urgent.search(search_string)
    else
      Contact.active.search(search_string)
    end
  end

  def self.display_title(show)
    show == 'inactive' ? 'Deleted Contacts' : 'Active Contacts'
  end

  def self.search(search)
    search ? where('lower(name) LIKE lower(?) ODER BY town_id', "%#{search}%") : all.order(:town_id)
  end
end
