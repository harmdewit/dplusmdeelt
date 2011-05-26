class Admin::ApplicationController < ActionController::Base
  before_filter :authenticate_admin!
  layout "admin/application"
  
  def index
    
  end
end
