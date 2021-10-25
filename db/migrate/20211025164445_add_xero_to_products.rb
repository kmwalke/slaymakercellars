class AddXeroToProducts < ActiveRecord::Migration[6.1]
  def up
    add_column :products, :case_size, :int, null: false, default: 12
    add_column :products, :xero_id, :string

    Product.all.each do |product|
      product.update(xero_id: product.name[-6..].upcase)
    end

    change_column :products, :xero_id, :string, null: false
    add_index :products, :xero_id, unique: true
  end

  def down
    remove_index :products, :xero_id
    remove_column :products, :case_size
    remove_column :products, :xero_id
  end
end
