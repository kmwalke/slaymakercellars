class AddTypeToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :category, :string, null: false, default: Product::CATEGORIES.first
    add_column :products, :is_public, :boolean, null: false, default: true
  end
end
