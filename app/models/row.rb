class Row < ActiveRecord::Base
  belongs_to :page, :dependent => :destroy
  has_many :columns, :dependent => :destroy
end
