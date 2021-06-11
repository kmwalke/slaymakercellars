class Note < ApplicationRecord
  belongs_to :contact
  belongs_to :resolved_by, class_name: 'User'

  validates :body, presence: true
  validates :contact_id, presence: true

  def resolved?
    resolved_at != nil
  end
end
