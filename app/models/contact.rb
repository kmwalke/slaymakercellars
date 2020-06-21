class Contact < ApplicationRecord
  belongs_to :town

  validates :name, presence: true, uniqueness: true
  validates :town_id, presence: true

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
      self.deleted_at = DateTime.now
      'archived'
    end
  end

  def undestroy
    self.deleted_at = nil
  end

  private

  def self.display_contacts(show, search_string)
    show == 'inactive' ? Contact.inactive.search(search_string) : Contact.active.search(search_string)
  end

  def self.display_title(show)
    show == 'inactive' ? 'Deleted Contacts' : 'Active Contacts'
  end

  def self.search(search)
    search ? where('lower(name) LIKE lower(?)', "%#{search}%") : all
  end
end
