class AddKegsToContacts < ActiveRecord::Migration[7.0]
  def change
    add_column :contacts, :num_kegs, :integer, null: false, default: 0
  end
end
