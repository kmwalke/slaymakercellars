class AddPickupCheckToContacts < ActiveRecord::Migration[6.1]
  def change
    add_column :contacts, :pickup_check, :boolean, null: false, default: false
  end
end
