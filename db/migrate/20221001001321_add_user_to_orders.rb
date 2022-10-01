class AddUserToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :assigned_to_id, :integer
  end
end
