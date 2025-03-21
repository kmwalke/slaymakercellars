class CreateMenuItem < ActiveRecord::Migration[8.0]
  def change
    create_table :menu_items do |t|
      t.string :name
      t.integer :on_prem_price
      t.integer :off_prem_price
    end
  end
end
