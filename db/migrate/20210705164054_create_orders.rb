class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.integer :contact_id, nil: false
      t.boolean :delivered, nil: false, default: false
      t.date :delivery_date
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
