class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.integer :linked_account_id
      t.integer :column_id
      t.integer :page_id
      t.string :service
      t.string :service_post_id
      t.string :post_type
      t.string :date_created
      t.string :link_to_post
      t.string :state
      t.integer :priority

      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
