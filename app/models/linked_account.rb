class LinkedAccount < ActiveRecord::Base
  has_many :facebook_pages
  has_many :posts
end
