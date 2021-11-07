class AddCaseDealToContact < ActiveRecord::Migration[6.1]
  def change
    add_column :contacts, :always_gets_case_deal, :boolean, null: false, default: false
  end
end
