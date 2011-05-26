require 'spec_helper'

describe PostsController do

  describe "GET 'magazine_page'" do
    it "should be successful" do
      get 'magazine_page'
      response.should be_success
    end
  end

end
