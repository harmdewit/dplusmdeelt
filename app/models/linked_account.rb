class LinkedAccount < ActiveRecord::Base
  has_many :facebook_pages, :dependent => :destroy
  has_many :posts, :dependent => :destroy
end
