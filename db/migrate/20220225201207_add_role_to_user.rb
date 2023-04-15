class AddRoleToUser < ActiveRecord::Migration[7.0]
  def up
    add_column :users, :role, :string

    User.update(role: User::ROLES[:customer])

    change_column :users, :role, :string, null: false
  end

  def down
    remove_column :users, :role
  end
end
