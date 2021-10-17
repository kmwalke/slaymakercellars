class CreateAwards < ActiveRecord::Migration[6.1]
  def change
    create_table :awards do |t|
      t.string :name, null: false
      t.integer :product_id, null: false
    end
  end
end
