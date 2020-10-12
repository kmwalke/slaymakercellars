class AddVinoshipperToProducts < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :vs_id, :string
    remove_column :products, :price_point, :float
    remove_column :products, :description, :text
  end
end
