class CreateNotes < ActiveRecord::Migration[6.0]
  def change
    create_table :notes do |t|
      t.text :content
      t.integer :contact_id
      t.integer :created_by_id
      t.integer :resolved_by_id
      t.datetime :resolved_at

      t.timestamps
    end
  end
end
