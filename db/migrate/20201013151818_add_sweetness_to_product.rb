class AddSweetnessToProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :sweetness, :integer
  end
end
