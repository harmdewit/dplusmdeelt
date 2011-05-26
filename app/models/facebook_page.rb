class FacebookPage < ActiveRecord::Base
  belongs_to :linked_account
  has_many :posts
end
