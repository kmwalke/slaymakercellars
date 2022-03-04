class AddReceivesEmailToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :receives_emails, :boolean, null: false, default: true
  end
end
