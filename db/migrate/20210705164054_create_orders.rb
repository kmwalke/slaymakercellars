class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.integer :contact_id, null: false
      t.boolean :delivered, null: false, default: false
      t.date :delivery_date
      t.date :fulfilled_on
      t.datetime :deleted_at
      t.string :customer_po
      t.text :comments
      t.integer :created_by_id, null: false
      t.integer :updated_by_id

      t.timestamps
    end
  end
end
