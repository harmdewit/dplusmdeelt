class Page < ActiveRecord::Base
  has_many :rows, :dependent => :destroy
  named_scope :by_created_at, :order_by => 'oldest_post_date'
  
  
  @@MAX_COLUMN_WIDTH = 12
  @@POSSIBLE_MIN_WIDTHS = [4, 3]
  @@POSSIBLE_MIN_HEIGHTS = [1]
  @@MAX_ROW_HEIGHT = 3
  @@ORIENTATIONS = ['none', 'none','none', 'footer', 'sidebar']
  @@MAX_ARTICLES = 4
  

  def self.initialize_page
    page = Page.create do |p|
      p.active = 'false'
      case @@ORIENTATIONS[rand(5)]
      when 'sidebar'
        p.page_type = 'sidebar'
        p.max_articles = rand(@@MAX_ARTICLES - 2) + 2
      when 'footer'
        p.page_type = 'footer'
        p.max_articles = rand(@@MAX_ARTICLES - 1) + 2
      when 'none'
        p.page_type = 'none'
        p.max_articles = rand(@@MAX_ARTICLES - 2) + 2
      end
    end
    page
  end

  def self.create_page(undisplayed_posts)
    undisplayed_posts.delete_if {|x| x.post_type != 'article'}
    if Page.find_by_active(false)
      page = Page.find_by_active(false)
    else
      page = initialize_page
    end
    
    while undisplayed_posts.length > page.max_articles
      newest_post_date = Time.local(1900, 1, 1)
      oldest_post_date = Time.now

      page_rows = get_rows(page)
      orientation = page_rows[:orientation]

      saved_rows = []

      page_rows[:rows].each do |row|
        saved_row = page.rows.create(:height => row[:row_height])
        row[:columns].each do |column|
          saved_column = saved_row.columns.create(:width => column[:column_width], :orientation => column[:orientation])
        end
        saved_rows << saved_row
      end     
      saved_rows.reverse!
      saved_rows.each do |row|
        row.columns.reverse!
        row.columns.each do |column|
          undisplayed_posts.first.update_attributes(:column_id => column.id)
          if DateTime.parse(undisplayed_posts.first.date_created) < oldest_post_date
            oldest_post_date = DateTime.parse(undisplayed_posts.first.date_created) 
          end
          if  DateTime.parse(undisplayed_posts.first.date_created) > newest_post_date
            newest_post_date = DateTime.parse(undisplayed_posts.first.date_created)
          end
          undisplayed_posts.delete(undisplayed_posts.first)
        end
      end
           
      page.update_attributes(:oldest_post_date => oldest_post_date, :newest_post_date => newest_post_date, :active => "true")
      page = initialize_page
    end
  end
      
  protected
  
  def self.get_rows(page)
      
    # get one of the orientations footer, sidebar or none and set the appropiate article section metrics
    case page.page_type
    when 'sidebar'
      min_width = 4
      max_width = @@MAX_COLUMN_WIDTH - 4
      min_height = @@POSSIBLE_MIN_HEIGHTS[0]
      max_height = @@MAX_ROW_HEIGHT
    when 'footer'
      min_width = @@POSSIBLE_MIN_WIDTHS[rand(1)]
      max_width = @@MAX_COLUMN_WIDTH
      min_height = @@POSSIBLE_MIN_HEIGHTS[0]        
      max_height = @@MAX_ROW_HEIGHT - 1
    when 'none'
      min_width = @@POSSIBLE_MIN_WIDTHS[rand(1)]
      max_width = @@MAX_COLUMN_WIDTH
      min_height = @@POSSIBLE_MIN_HEIGHTS[0]
      max_height = @@MAX_ROW_HEIGHT
    end
    
    rows = []# {:max_articles => max_articles}]
    
    height_sum = 0
    i = 0
    
    
    until (height_sum == max_height) # || (i == max_articles)
      unless i >= (page.max_articles - 1)
        row_height = rand(max_height/min_height - height_sum/min_height)*min_height + min_height
      else 
        row_height = max_height - height_sum
      end
      height_sum += row_height
    
      width_sum = 0
      columns = []
      until (width_sum == max_width)
        unless i >= (page.max_articles - 1)
          column_width = rand(max_width/min_width - width_sum/min_width)*min_width + min_width
          if (column_width == max_width) && (row_height == max_height) && (page.page_type == 'footer' or 'none')
            column_width = column_width - min_width 
          end
        else
          column_width = max_width - width_sum
        end
        width_sum += column_width
        
        if column_width >= (row_height * 3)
          orientation = 'horizontal'
        else
          orientation = 'vertical'
        end
        columns.push(:column_width => column_width, :orientation => orientation, :post => i)
        
        i += 1
      end
      push = rand(1)
      if push 
        rows.push({:row_height => row_height, :columns => columns})
      else
        rows.shift({:row_height => row_height, :columns => columns})
      end
      
    end
    
    if i > page.max_articles
      get_rows(page)
    else
      {:rows => rows, :orientation => page.page_type}
    end
  end
  
  # def make_album_rows
  #   page_orientation = 'none'
  # 
  #   max_width = @@MAX_COLUMN_WIDTH
  #   min_height = @@POSSIBLE_MIN_HEIGHTS[0]
  #   max_height = @@MAX_ROW_HEIGHT + 1
  #   max_articles = 6# rand(@@MAX_ARTICLES) + 2
  # 
  # 
  #   
  #   
  #   until articles.count < max_articles
  #     rows = []
  # 
  #     height_sum = 0
  #     articles_count = 0
  #     
  #     until (height_sum >= max_height) # || (i == max_articles)
  #       unless articles_count >= (max_articles - 1)
  #         row_height = rand((max_height - height_sum) / min_height)*min_height + min_height
  #         if row_height >= max_height - 1 then row_height = max_height - 2 end
  #       else 
  #         row_height = max_height - height_sum
  #       end
  #       height_sum += row_height
  #     
  #       min_width =  @@POSSIBLE_MIN_WIDTHS[rand(2)]
  #       width_sum = 0
  #       columns = []
  #       until (width_sum == max_width)
  #         unless i >= (max_articles - 1)
  #           column_width = rand((max_width- width_sum) /min_width)*min_width + min_width
  #           if column_width >= max_width - min_width then column_width = max_width - 2 * min_width end
  #         else
  #           column_width = max_width - width_sum
  #         end
  #         width_sum += column_width
  #       
  #         if column_width >= (row_height * 3)
  #           orientation = 'horizontal'
  #         else
  #           orientation = 'vertical'
  #         end
  # 
  #         columns.push(:column_width => column_width, :orientation => orientation)
  #       
  #         articles_count += 1
  #       end
  #       push = rand(2)
  #       if push 
  #         rows.push({:row_height => row_height, :columns => columns})
  #       else
  #         rows.shift({:row_height => row_height, :columns => columns})
  #       end
  #     
  #     end
  #   
  # 
  #     {:rows => rows, :orientation => page_orientation}
  #   end
  # end
  
end
