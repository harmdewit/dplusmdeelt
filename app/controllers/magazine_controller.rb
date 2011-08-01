class MagazineController < ApplicationController
  @@MAX_COLUMN_WIDTH = 12
  @@POSSIBLE_MIN_WIDTHS = [4, 3]
  @@POSSIBLE_MIN_HEIGHTS = [1]
  @@MAX_ROW_HEIGHT = 3
  @@ORIENTATIONS = ['none', 'none','sidebar', 'sidebar', 'footer', 'footer']#, 'footer', 'none', 'none', 'none']
  @@MAX_ARTICLES = 4
    
  def index
    newest_page = Page.find_by_active('true', :order => 'oldest_post_date DESC')

    unless newest_page.nil?
      newest_page_date = newest_page.oldest_post_date.to_time.localtime
      year = newest_page_date.year
      month = newest_page_date.month
      
      unless admin_signed_in?
        @pages = Page.where("newest_post_date >= :start_date AND oldest_post_date <= :end_date AND active = 'true'", {\
          :start_date => Time.local(year, month, 1).beginning_of_month, 
          :end_date => Time.local(year, month, 1).end_of_month
        }).order('oldest_post_date ASC')
      else
        @pages = Page.where("newest_post_date >= :start_date AND oldest_post_date <= :end_date AND active IN (:active_values)", {
          :start_date => Time.local(year, month, 1).beginning_of_month, 
          :end_date => Time.local(year, month, 1).end_of_month, 
          :active_values => ['true', 'hidden']
        }).order('oldest_post_date ASC')
      end
      @posts = Post.find_all_by_post_type('article')
      @statuses = Post.find_all_by_post_type('status', :order => 'date_created DESC')
      @statuses_iterator = 0;

      get_active_dates(newest_page_date.year, newest_page_date.month)
    else
      render 'error'
    end
  end

  def archive
    year = params[:year]
    month = params[:month]
    
    unless admin_signed_in?
    @pages = Page.where("newest_post_date >= :start_date AND oldest_post_date <= :end_date AND active = 'true'", {\
      :start_date => Time.local(year, month, 1).beginning_of_month, 
      :end_date => Time.local(year, month, 1).end_of_month
    }).order('oldest_post_date ASC')
    else
      @pages = Page.where("newest_post_date >= :start_date AND oldest_post_date <= :end_date AND active IN (:active_values)", {
        :start_date => Time.local(year, month, 1).beginning_of_month, 
        :end_date => Time.local(year, month, 1).end_of_month, 
        :active_values => ['true', 'hidden']
      }).order('oldest_post_date ASC')
    end
    unless @pages.nil?    
      get_active_dates(year.to_i, month.to_i)
      @posts = Post.find_all_by_post_type('article') 
      @statuses = Post.find_all_by_post_type('status', :order => 'date_created DESC')
      @statuses_iterator = 0;
      render 'index'
    else
      render 'error'
    end
  end
  
  def tumblr_post
    tumblr_post_id = params[:id]
    tumblr_post = Post.find_by_service_post_id_and_service(tumblr_post_id, 'tumblr')
    
    unless tumblr_post.nil?
      year = tumblr_post.date_created.to_time.localtime.year
      month = tumblr_post.date_created.to_time.localtime.month
      
      unless admin_signed_in?
        @pages = Page.where("newest_post_date >= :start_date AND oldest_post_date <= :end_date AND active IN :active", {\
          :start_date => Time.local(year, month, 1).beginning_of_month, 
          :end_date => Time.local(year, month, 1).end_of_month,
          :active => ['true', 'hidden']
        }).order('oldest_post_date ASC')
      else
        @pages = Page.where("newest_post_date >= :start_date AND oldest_post_date <= :end_date AND active IN (:active_values)", {
          :start_date => Time.local(year, month, 1).beginning_of_month, 
          :end_date => Time.local(year, month, 1).end_of_month, 
          :active_values => ['true', 'hidden']
        }).order('oldest_post_date ASC')
      end
      get_active_dates(year.to_i, month.to_i)
      @posts = Post.find_all_by_post_type('article') 
      @statuses = Post.find_all_by_post_type('status', :order => 'date_created DESC')
      @statuses_iterator = 0;
      
      found_page = tumblr_post.column.row.page
      @pages.each_index do |i|
        if found_page == @pages[i]
          @found_page = i
        end
      end
      render 'index'
    else
      render 'error'
    end
  end
  
  def get_active_dates(searched_year, searched_month)
    start_date = Page.find_all_by_active(['true', 'hidden'], :order => 'oldest_post_date ASC').first.oldest_post_date.to_time.localtime
    end_date = Page.find_all_by_active(['true', 'hidden'], :order => 'newest_post_date DESC').first.newest_post_date.to_time.localtime

    @years = []
    @next_date
    @previous_date
    (start_date.year..end_date.year).each do |y|
      months = []

      # Get all months between start_date and the beginning of that year.
      if y == start_date.year
        mo_start = Date.new(start_date.year, 1).month
        mo_end = start_date.month - 1
        (mo_start..mo_end).each do |m|
          months << {:month => m, :active => false}
        end
      end


       mo_start = (start_date.year == y) ? start_date.month : 1
       mo_end = (end_date.year == y) ? end_date.month : 12

       (mo_start..mo_end).each do |m|
         if (y == searched_year && m == searched_month)
           months << {:month => m, :active => true, :current => true}
         else
           months << {:month => m, :active => true, :current => false}
         end

         if (y == searched_year - 1 && m == 12 && searched_month == 1)
           @previous_date = {:year => y, :month => m}
         elsif (y == searched_year && m == searched_month - 1)
           @previous_date = {:year => y, :month => m}
         end
         
         if (y == searched_year + 1 && m == 1 && searched_month == 12)
           @next_date = {:year => y, :month => m}
         elsif (y == searched_year && m == searched_month + 1)
           @next_date = {:year => y, :month => m}
         end
       end

       # Get all months between end_date and the end of that year.         
       if y == end_date.year
          mo_start = end_date.month + 1
          mo_end = Date.new(end_date.year, -1).month
          
          (mo_start..mo_end).each do |m|
            months << {:month => m, :active => false}
          end
        end

       months.reverse!
       if y == searched_year
         @years.push({:year => y, :months => months, :current => true})
       else
         @years.push({:year => y, :months => months, :current => false})
       end

    end
    @years.reverse!
  end
  
  def hide_page
    page = Page.find(params[:id])
    if page.active == 'true'
      page.update_attributes(:active => 'hidden')
    else
      page.update_attributes(:active => 'true')      
    end
    
    redirect_to request.env["HTTP_REFERER"] + "#page_#{params[:page_hash].to_i}"
  end
  
  def rebuild_page
    page = Page.find(params[:id])
    Page.rebuild(page)
    redirect_to request.env["HTTP_REFERER"] + "#page_#{params[:page_hash].to_i}"
  end
  
  def frontpage
    @posts = Post.find_all_by_post_type('article')
  end
  
  def error
    
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
