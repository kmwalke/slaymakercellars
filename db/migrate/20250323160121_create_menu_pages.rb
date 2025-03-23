class CreateMenuPages < ActiveRecord::Migration[8.0]
  def change
    create_table :menu_pages do |t|
      t.integer :position
    end
  end
end
