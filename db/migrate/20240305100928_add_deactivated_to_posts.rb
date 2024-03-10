class AddDeactivatedToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :deactivated, :boolean, default: false
  end
end
