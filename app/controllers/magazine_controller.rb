class MagazineController < ApplicationController
  @@MAX_COLUMN_WIDTH = 12
  @@POSSIBLE_MIN_WIDTHS = [4, 3]
  @@POSSIBLE_MIN_HEIGHTS = [1]
  @@MAX_ROW_HEIGHT = 3
  @@ORIENTATIONS = ['none', 'none','none', 'sidebar', 'footer']#, 'footer', 'none', 'none', 'none']
  @@MAX_ARTICLES = 4
    
  def initialize
    super()
    # start_date = Page.find_all_by_active('true').by_created_at.first.oldest_post_date.to_time.localtime
    start_date = Page.find_all_by_active('true', :order => 'oldest_post_date DESC').first.oldest_post_date.to_time.localtime
    now = Time.now.localtime

    @years = []
    (start_date.year..now.year).each do |y|
      months = []
       mo_start = (start_date.year == y) ? start_date.month : 1
       mo_end = (now.year == y) ? now.month : 12

       (mo_start..mo_end).each do |m|  
           months << m
       end
       months.reverse!
       
       @years.push({:year => y, :months => months})
    end
    @years.reverse!
  end
  
  def index   
    @posts = Post.find_all_by_post_type('article')
    @pages = Page.find_all_by_active('true', :order => 'oldest_post_date DESC')
    @statuses = Post.find_all_by_post_type('status', :order => 'date_created ASC')

  end

  def archive
    @posts = Post.find_all_by_post_type('article')
    
    @statuses = Post.find_all_by_post_type('status', :order => 'date_created ASC')
    @pages = Page.where("newest_post_date >= :start_date AND oldest_post_date <= :end_date AND active = true", {\
      :start_date => Time.local(params[:year], params[:month], 1).beginning_of_month, 
      :end_date => Time.local(params[:year], params[:month], 1).end_of_month
    }).order('oldest_post_date DESC')
    @begin_time = Time.local(params[:year], params[:month], 1).beginning_of_month
    @end_time = Time.local(params[:year], params[:month], 1).end_of_month

    render 'index'
    
  end
  
  def frontpage
    @posts = Post.find_all_by_post_type('article')
  end
  
  def images
    @posts = Post.find_all_by_post_type('image')
    @pages = [1, 1, 1, 1, 1]
  end
  
  def images_alternative
    @image_posts = Post.find_all_by_post_type('image')
    @pages = [1, 1, 1, 1, 1]
  end
  
  # def images2
  #   @posts = Post.find_all_by_post_type('image')
  #   @landscapes = []
  #   @portraits = []
  #   @posts.each do |post|
  #     if post.image.width >= post.image.height
  #       @landscapes.push(post)
  #     else
  #       @portraits.push(post)
  #     end
  #   end
  #   @pages = []
  #   
  #   for i in 0..10
  #     @pages.push(make_album_rows)
  #   end
  # 
  # end
  # 


end
