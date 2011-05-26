class CreateStatuses < ActiveRecord::Migration
  def self.up
    create_table :statuses do |t|
      t.integer :post_id
      t.string :text

      t.timestamps
    end
  end

  def self.down
    drop_table :statuses
  end
end
