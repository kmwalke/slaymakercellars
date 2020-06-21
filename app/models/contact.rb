class Contact < ApplicationRecord
  belongs_to :town

  validates :name, presence: true, uniqueness: true
  validates :town_id, presence: true

  scope :active, -> { where(deleted_at: nil) }
  scope :inactive, -> { where.not(deleted_at: nil) }

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
end
