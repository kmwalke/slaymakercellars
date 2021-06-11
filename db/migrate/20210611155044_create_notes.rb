class CreateNotes < ActiveRecord::Migration[6.1]
  def change
    create_table :notes do |t|
      t.text :body
      t.integer :contact_id
      t.integer :created_by_id
      t.datetime :resolved_at
      t.integer :resolved_by_id

      t.timestamps
    end
  end
end
