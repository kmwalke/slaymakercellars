class CreateRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :roles do |t|
      t.string :name
    end
    add_index :roles, :name, unique: true
    Role.create(name: User::ROLES[:admin])
    Role.create(name: User::ROLES[:customer])
  end
end
