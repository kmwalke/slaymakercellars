class CreateMenuSubSection < ActiveRecord::Migration[8.0]
  def change
    create_table :menu_sub_sections do |t|
      t.string :name
      t.integer :menu_section_id
      t.integer :position
      t.string :on_prem_name
      t.string :off_prem_name
    end
  end
end
