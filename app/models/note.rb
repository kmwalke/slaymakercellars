class Note < ApplicationRecord
  belongs_to :contact

  validates :body, presence: true
  validates :contact_id, presence: true

  def resolved?
    resolved_at != nil
  end
end
