class AddInProductionToProducts < ActiveRecord::Migration[6.1]
  def change
    add_column :products, :in_production, :boolean, null: false, default: true
  end
end
