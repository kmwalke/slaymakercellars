class AddUrlToContact < ActiveRecord::Migration[6.0]
  def change
    add_column :contacts, :url, :string
  end
end
