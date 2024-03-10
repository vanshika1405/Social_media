class AddLastDeclinedAtToFriendships < ActiveRecord::Migration[7.1]
  def change
    add_column :friendships, :last_declined_at, :datetime
  end
end
