class AddSharedPostIdToPosts < ActiveRecord::Migration[7.1]
  def change
    add_column :posts, :shared_post_id, :integer
  end
end
