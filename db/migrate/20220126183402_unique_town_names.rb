class UniqueTownNames < ActiveRecord::Migration[7.0]
  def change
    add_index :towns, [:name, :state_id], unique: true
  end
end
