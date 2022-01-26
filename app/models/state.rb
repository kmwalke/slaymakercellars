class State < ApplicationRecord
  has_many :towns

  validates :name, presence: true
  validates :abbreviation, presence: true

  def self.with_active_towns
    State.all.includes(towns: :contacts)
         .where(contacts: { is_public: true, deleted_at: nil })
         .order('states.name ASC, towns.name ASC, contacts.name ASC')
  end
end
