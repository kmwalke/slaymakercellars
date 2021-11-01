class AddPaperlessBillingToContacts < ActiveRecord::Migration[6.1]
  def change
    add_column :contacts, :paperless_billing, :boolean, null: false, default: false
  end
end
