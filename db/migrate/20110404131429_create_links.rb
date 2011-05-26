class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.integer :post_id
      t.string :link_url
      t.string :text
      t.string :description

      t.timestamps
    end
  end

  def self.down
    drop_table :links
  end
end
