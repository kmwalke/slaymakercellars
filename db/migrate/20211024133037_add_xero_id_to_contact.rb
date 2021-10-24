class AddXeroIdToContact < ActiveRecord::Migration[6.1]
  def change
    add_column :contacts, :xero_id, :string
    add_column :contacts, :external_notes, :text
    rename_column :contacts, :description, :internal_notes
  end
end
