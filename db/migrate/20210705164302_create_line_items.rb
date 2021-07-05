class CreateLineItems < ActiveRecord::Migration[6.1]
  def change
    create_table :line_items do |t|
      t.integer :order_id, nil: false
      t.integer :product_id, nil: false
      t.integer :quantity, nil: false
    end
  end
end
