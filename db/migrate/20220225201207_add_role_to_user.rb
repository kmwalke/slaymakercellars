class AddRoleToUser < ActiveRecord::Migration[7.0]
  def up
    add_column :users, :role, :string

    User.update_all(role: 'Customer')

    change_column :users, :role, :string, null: false
    # add_foreign_key :users, :role, :roles, :name
  end

  def down
    remove_column :users, :role
  end
end
