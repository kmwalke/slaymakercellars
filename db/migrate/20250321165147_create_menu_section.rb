class CreateMenuSection < ActiveRecord::Migration[8.0]
  def change
    create_table :menu_sections do |t|
      t.string :name, null: false
      t.text :verbiage
      t.integer :position
    end
  end
end
