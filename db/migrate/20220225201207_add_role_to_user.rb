class AddRoleToUser < ActiveRecord::Migration[7.0]
  def up
    add_column :users, :role, :string
    add_foreign_key :users, :roles, column: :role, primary_key: :name

    User.update_all(role: User::ROLES[:customer])

    change_column :users, :role, :string, null: false
  end

  def down
    remove_foreign_key :users, :roles
    remove_column :users, :role
  end
end
