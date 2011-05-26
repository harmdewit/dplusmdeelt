class CreatePages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :active
      t.integer :max_articles
      t.string :page_type
      t.string :newest_post_date
      t.string :oldest_post_date
      t.timestamps
    end
  end

  def self.down
    drop_table :pages
  end
end
