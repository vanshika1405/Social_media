class CreateComments < ActiveRecord::Migration[7.1]
  def change
    create_table :comments do |t|
      t.text :content
      t.references :user, null: false, foreign_key: true
      t.string :commentable_type
      t.integer :commentable_id

      t.timestamps
    end
  end
end
