class AddResolutionToNotes < ActiveRecord::Migration[7.0]
  def change
    add_column :notes, :resolution, :text
  end
end
