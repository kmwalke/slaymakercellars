class AddSalesRep < ActiveRecord::Migration[7.0]
  def change
    create_table :sales_reps do |t|
      t.string :name
      t.string :email
    end
    add_column :contacts, :sales_rep_id, :integer
  end
end
