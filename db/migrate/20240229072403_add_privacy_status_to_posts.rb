class AddPrivacyStatusToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :privacy_status, :string
  end
end
