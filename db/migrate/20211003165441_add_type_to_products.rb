class AddTypeToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :category, :string, null: false, default: Product::CATEGORIES[:flagship]
  end
end
