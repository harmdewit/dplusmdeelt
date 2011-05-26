class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.integer :post_id
      t.string :description
      t.string :thumbnail
      t.string :data
      t.integer :width
      t.integer :height

      t.timestamps
    end
  end

  def self.down
    drop_table :images
  end
end
