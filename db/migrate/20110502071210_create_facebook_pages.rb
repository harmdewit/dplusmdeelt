class CreateFacebookPages < ActiveRecord::Migration
  def self.up
    create_table :facebook_pages do |t|
      t.integer :linked_account_id
      t.string :provider
      t.string :uid
      t.string :name
      t.string :email
      t.string :nickname
      t.string :first_name
      t.string :last_name
      t.string :location
      t.string :description
      t.string :image
      t.string :phone
      t.string :urls
      t.string :token
      t.string :secret
      
      t.timestamps
    end
  end

  def self.down
    drop_table :facebook_pages
  end
end
