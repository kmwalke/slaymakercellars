class AddXeroToProducts < ActiveRecord::Migration[6.1]
  def up
    add_column :products, :case_size, :int, null: false, default: 12
    add_column :products, :xero_id, :string
    add_column :products, :xero_code, :string

    Product.all.each_with_index do |product, i|
      product.update(xero_code: "#{product.name[0..4]}_#{i}")
    end

    change_column :products, :xero_code, :string, null: false
    add_index :products, :xero_code, unique: true
  end

  def down
    remove_index :products, :xero_code
    remove_column :products, :case_size
    remove_column :products, :xero_id
    remove_column :products, :xero_code
  end
end
