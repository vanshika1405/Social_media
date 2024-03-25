class ModifyBlockedUsersForeignKeys < ActiveRecord::Migration[6.0]
  def change
    
    remove_foreign_key :blocked_users, :blocked_users

    
    add_foreign_key :blocked_users, :users, column: :user_id
    add_foreign_key :blocked_users, :users, column: :blocked_user_id
  end
end

