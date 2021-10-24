class AddXeroIdToContact < ActiveRecord::Migration[6.1]
  def change
    add_column :contacts, :xero_id, :string
  end
end
