class SetPickupCheckDefualt < ActiveRecord::Migration[7.0]
  def up
    change_column :contacts, :pickup_check, :boolean, null: false, default: true
  end

  def down
    change_column :contacts, :pickup_check, :boolean, null: false, default: false
  end
end
