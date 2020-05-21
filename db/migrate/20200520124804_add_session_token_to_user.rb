class AddSessionTokenToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :session_token, :string, limit: 255
    add_index :users, :session_token
  end
end
