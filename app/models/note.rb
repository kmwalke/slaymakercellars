class Note < ApplicationRecord
  belongs_to :contact
  belongs_to :created_by, class_name: 'User'

  validates :body, presence: true

  def resolved?
    resolved_at != nil
  end
end
