class AddPrivacyToPosts < ActiveRecord::Migration[6.0]
  def change
    add_column :posts, :privacy_status, :string, default: 'Public'
  end
end

