class Contact < ApplicationRecord
  belongs_to :town

  validates :name, presence: true, uniqueness: true
  validates :town_id, presence: true

  validate :proper_url

  scope :active, -> { where(deleted_at: nil) }
  scope :inactive, -> { where.not(deleted_at: nil) }

  def self.display(show = 'active', search_string = nil)
    [show, display_contacts(show, search_string), display_title(show)]
  end

  def destroy
    if deleted_at.present?
      super
      'destroyed'
    else
      update(deleted_at: DateTime.now)
      'archived'
    end
  end

  def undestroy
    update(deleted_at: nil)
  end

  def self.display_contacts(show, search_string)
    show == 'inactive' ? Contact.inactive.search(search_string) : Contact.active.search(search_string)
  end

  def self.display_title(show)
    show == 'inactive' ? 'Deleted Contacts' : 'Active Contacts'
  end

  def self.search(search)
    search ? where('lower(name) LIKE lower(?) ODER BY town_id', "%#{search}%") : all.order(:town_id)
  end

  private

  def proper_url
    url_error unless url.blank? || uri.is_a?(URI::HTTP) && !uri.host.nil?
  rescue URI::InvalidURIError
    url_error
  end

  def url_error
    errors.add(:url, 'URL must be valid and start with http')
  end

  def uri
    @uri ||= URI.parse(url)
  end
end
