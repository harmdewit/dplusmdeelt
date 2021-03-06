class CreateColumns < ActiveRecord::Migration
  def self.up
    create_table :columns do |t|
      t.integer :row_id
      t.integer :width
      t.string :orientation

      t.timestamps
    end
  end

  def self.down
    drop_table :columns
  end
end
