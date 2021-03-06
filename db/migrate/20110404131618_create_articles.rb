class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.integer :post_id
      t.string :title
      t.string :original_body, :limit => 16777216
      t.string :body, :limit => 16777216
      t.string :image_data
      t.integer :image_width
      t.integer :image_height

      t.timestamps
    end
  end

  def self.down
    drop_table :articles
  end
end
