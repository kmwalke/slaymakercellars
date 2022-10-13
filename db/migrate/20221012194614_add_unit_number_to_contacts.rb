class AddUnitNumberToContacts < ActiveRecord::Migration[7.0]
  def up
    Contact.where(address: nil).update_all(address: '')

    add_column :contacts, :unit_number, :string
    change_column :contacts, :address, :string, null: false
  end

  def down
    remove_column :contacts, :unit_number
    change_column :contacts, :address, :text
  end
end
