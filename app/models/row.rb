class Row < ActiveRecord::Base
  belongs_to :page
  has_many :columns, :dependent => :destroy
end
