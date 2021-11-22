class AddPublicToContacts < ActiveRecord::Migration[6.1]
  def change
    add_column :contacts, :is_public, :boolean, null: false, default: true
  end
end
