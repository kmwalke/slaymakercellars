class CreateLineItems < ActiveRecord::Migration[6.0]
  def change
    create_table :line_items do |t|
      t.integer :quantity
      t.integer :product_id
      t.string :description
      t.float :price
    end
  end
end
