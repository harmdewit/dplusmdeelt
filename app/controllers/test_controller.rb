require 'hashie'
require "open-uri"
require "image_size"
require 'net/http'
class TestController < ApplicationController
  def index
    Post.synchronize
  end

end
