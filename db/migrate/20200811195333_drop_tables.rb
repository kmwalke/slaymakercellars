class DropTables < ActiveRecord::Migration[6.0]
  def up
    drop_table :products
    drop_table :contacts
    drop_table :states
    drop_table :towns
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
