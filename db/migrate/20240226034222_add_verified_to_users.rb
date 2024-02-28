# db/migrate/YYYYMMDDHHMMSS_add_verified_to_users.rb
class AddVerifiedToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :verified, :boolean, default: false
  end
end
