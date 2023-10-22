class AddPhoneToSalesRep < ActiveRecord::Migration[7.1]
  def change
    add_column :sales_reps, :phone, :string
  end
end
