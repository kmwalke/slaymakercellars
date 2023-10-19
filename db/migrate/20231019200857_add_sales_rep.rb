class AddSalesRep < ActiveRecord::Migration[7.0]
  def change
    create_table :sales_reps do |t|
      t.string :name
      t.integer :contact_id
    end
  end
end
