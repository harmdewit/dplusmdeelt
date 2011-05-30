class Column < ActiveRecord::Base
  has_one :post, :dependent => :destroy
  belongs_to :row, :dependent => :destroy
end
