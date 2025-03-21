class CreateMenuWineries < ActiveRecord::Migration[8.0]
  def change
    create_table :menu_wineries do |t|
      t.string :name, null: false
    end
  end
end
