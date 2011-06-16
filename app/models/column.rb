class Column < ActiveRecord::Base
  has_one :post
  belongs_to :row
end
