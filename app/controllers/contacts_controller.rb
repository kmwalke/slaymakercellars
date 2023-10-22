class ContactsController < ApplicationController
  def index
    @states = State.includes(towns: :contacts)
                   .where(contacts: { is_public: true, deleted_at: nil })
                   .order('states.name ASC, towns.name ASC, contacts.name ASC')
  end
end
