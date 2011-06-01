# config/initializers/configuration.rb
class Configuration
  class << self
    attr_accessor :twitter_username
    attr_accessor :disqus_shortname
  end
end
