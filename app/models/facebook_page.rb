class FacebookPage < ActiveRecord::Base
  belongs_to :linked_account
  has_many :posts, :dependent => :destroy, :foreign_key => :linked_account_id
end
