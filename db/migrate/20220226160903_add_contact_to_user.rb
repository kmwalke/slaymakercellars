class AddContactToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :contact_id, :integer
  end
end
