require 'hashie'
require "open-uri"
require "image_size"
require 'net/http'
class Post < ActiveRecord::Base
  
  belongs_to :column, :dependent => :destroy
  belongs_to :linked_account
  belongs_to :facebook_page, :foreign_key => :linked_account_id
  has_one :article, :dependent => :destroy
  has_one :status, :dependent => :destroy
  has_one :image, :dependent => :destroy
  has_one :video, :dependent => :destroy
  has_one :link, :dependent => :destroy
  validates_presence_of :post_type 
  validates_uniqueness_of :service_post_id, :scope => :service
  
  def self.synchronize
    LinkedAccount.all.each do |la|
      case la.provider
      when 'twitter'
        twitter_posts(la)
      when 'facebook'
        la.facebook_pages.each do |fp|
          facebook_posts(fp)
        end
      when 'tumblr'
        tumblr_posts(la)

      end
    end
    undisplayed_posts = Post.find_all_by_column_id(nil, :order => 'created_at DESC')
    Page.create_page(undisplayed_posts)
  end
  
  def self.synchronize_without_saving
    posts = get_posts_from_social_media
  end
  
  def create_facebook_posts
    
  end
  
  def self.get_posts_from_social_media
    @@client = OAuth2::Client.new('1bf37745bbffea2233a3a0c78e4918fe', '607ffab3d43a1c58d2ed4326b933ed64', :site => 'https://graph.facebook.com')
    posts.sort! {|y,x| y.combined_created_at <=> x.combined_created_at}
  end
  
  def self.twitter_posts(la)
    twitter_response = Twitter.user_timeline(la.nickname)

    # Twitter posts
    twitter_response.each do |p|
      post = la.posts.build
      post.service = 'twitter'
      post.date_created = DateTime.parse(p.created_at)
    
      # Do not save Twitter posts coming from the registered applications Facebook and Tumblr
      
      unless p['source'].match(/http:\/\/www.tumblr.com\//) || p['source'].match(/http:\/\/www.facebook.com\/twitter/)
        post.service_post_id = p['id']
        post.post_type = 'status'
        post.link_to_post = "http://twitter.com/#{p['user']['name']}/status/#{p['id']}"
        if post.save
          Status.create do |item| 
            item.post_id = post.id
            item.text = p.text
          end
        end
      end
    end
  end
  
  def self.facebook_posts(la)
    # grab the facebook page feed
    url = URI.parse("//graph.facebook.com/#{la.uid}/feed")
    req = Net::HTTP::Get.new(url.path)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    # Turn json into an hash   
    j = ActiveSupport::JSON 
    facebook_hash = j.decode(res.body)
    # enhance the facebook feed to a readable object
    mash = Hashie::Mash.new
    mash.facebook = facebook_hash
    
    mash.facebook.data.each do |p|
      post = la.linked_account.posts.build
      post.service = 'facebook'
      post.date_created = DateTime.parse(p.created_time)
    
      post.service_post_id = p['id']
      service_post_id_without_user_id = p['id'].sub(p['from']['id'] + '_', '')
      post.link_to_post = "http://www.facebook.com/permalink.php?story_fbid=#{service_post_id_without_user_id}&id=#{p['from']['id']}"
      
      case p['type']
      when 'status'
        post.post_type = 'status'
        if post.save
          Status.create do |item| 
            item.post_id = post.id
            item.text = p.message
          end
        end
      when 'link'
        post.post_type = 'link'
        if post.save
          Link.create do |item| 
            item.post_id = post.id
            item.link_url = p['link']
            item.text = p['name']
            item.description = p['description']
          end
        end
      when 'photo'
        post.post_type = 'image'
        if post.save
          Image.create do |item| 
            item.post_id = post.id
            item.thumbnail = p['picture']
            item.data = p['picture'].sub(/_s.jpg/, '_n.jpg')
            item.description = p['message']
            open(item.data, "rb") do |fh|
              item.width = ImageSize.new(fh.read).get_width
            end
            open(item.data, "rb") do |fh|              
              item.height = ImageSize.new(fh.read).get_height
            end
          end
        end
      when 'tagged'
        # p['type'] = 'image'
        # p['url'] = p.picture
        # p['description'] = p.description
        # link could be added
        # images.push(p)
      when 'video'
        post.post_type = 'video'
        if post.save
          Video.create do |item| 
            item.post_id = post.id
            item.title = p['name']
            item.body =  "<object width='400' height='224' ><param name='allowfullscreen' value='true' /><param name='movie' value='http://www.facebook.com/v/#{p['object_id']}' /><embed src='http://www.facebook.com/v/#{p['object_id']}' type='application/x-shockwave-flash' allowfullscreen='true' width='400' height='224'></embed></object>"
          end
        end
      end
    end    
  end
  
  def self.tumblr_posts(la)
    url = URI.parse("http://#{la.uid}.tumblr.com/api/read/json")
    req = Net::HTTP::Get.new(url.path)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    # Tumblr returns a false json object, some modification is needed
    tumblr_json = res.body.gsub('var tumblr_api_read = ', '')
    tumblr_json = tumblr_json.gsub(';', '')
    # Turn Tumblr json into an hash
    j = ActiveSupport::JSON
    tumblr_hash = j.decode(tumblr_json)
    # Replace the minus(-) signs with underscores(_)
    tumblr_hash = modify_hash_keys(j.decode(tumblr_json))
    # Turn the hash into a readable object
    mash = Hashie::Mash.new
    mash.tumblr = tumblr_hash

    # Tumblr Posts    
    mash.tumblr.posts.each do |p|
      post = la.posts.build
      post.service = 'tumblr'
      post.date_created = DateTime.parse(p.date)
      post.service_post_id = p['id']
      post.link_to_post = p['url']
      
      case p['type']
      when 'regular'
        post.post_type = 'article'
        if post.save
          Article.create do |item| 
            item.post_id = post.id
            item.title = p['regular_title']
            item.original_body = p['regular_body']
            image_element = Nokogiri::HTML.parse(p['regular_body']).search('img')
            
            if image_element.presence 
              item.image_data = image_element.first['src']
            end
            image_elements = p['regular_body'].scan(/<img\b[^>]*(\/>)/)
            if image_elements.presence
              image_elements.each do |image_element|
                p['regular_body'] = p['regular_body'].sub(/<img\b[^>]*(\/>)/, '')
              end
            end              
            if item.image_data.presence
              open(item.image_data, "rb") do |fh|
                item.image_width = ImageSize.new(fh.read).get_width
              end
              open(item.image_data, "rb") do |fh|              
                item.image_height = ImageSize.new(fh.read).get_height
               end
            end
            item.body = p['regular_body']
          end
        end
      when 'photo'
        post.post_type = 'image'
        if post.save
          Image.create do |item| 
            item.post_id = post.id
            item.thumbnail = p['photo_url_75']
            item.data = p['photo_url_400']
            item.description = p['photo_caption']
            open(item.data, "rb") do |fh|
              item.width = ImageSize.new(fh.read).get_width
            end
            open(item.data, "rb") do |fh|              
              item.height = ImageSize.new(fh.read).get_height
            end
          end
        end
      when 'quote'
        # iets?
      when 'link'
        post.post_type = 'link'
        if post.save
          Link.create do |item| 
            item.post_id = post.id
            item.description = p['link_description']
            item.link_url = p['link_url']
            item.text = p['link_text']
          end
        end
      when 'conversation'
        #iets
      when 'video'
        post.post_type = 'video'
        if post.save
          Video.create do |item| 
            item.post_id = post.id
            item.title = p['title']
            item.body = p['embed']
            # item.description = p['video_caption']
          end
        end
      when 'audio'
        # audios.push(p)
        # Facebook posts
      end
    end
  end

  def self.modify_hash_keys(data)
    case data
    when Hash
      data.inject({}) do |h,(k,v)|
        h[(k.respond_to?(:tr) ? k.tr('-', '_') : k)] = modify_hash_keys(v)
        h
      end
    when Array
      data.map { |i| modify_hash_keys(i) }
    else
      data
    end
  end

end

