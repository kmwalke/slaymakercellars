class AddRubocopRecommendations < ActiveRecord::Migration[7.0]
  def change
    add_index :contacts, :name, unique: true
    add_index :products, :name, unique: true
  end
end
