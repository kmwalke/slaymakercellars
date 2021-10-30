class AddXeroToOrders < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :xero_id, :string
  end
end
