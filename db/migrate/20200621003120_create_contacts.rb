class CreateContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :phone
      t.string :email
      t.string :contact_point
      t.text :address
      t.text :description
      t.datetime :deleted_at
      t.integer :town_id

      t.timestamps
    end
  end
end
