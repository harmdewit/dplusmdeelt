require "spec_helper"

describe Admin::LinkedAccountsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/admin_linked_accounts" }.should route_to(:controller => "admin_linked_accounts", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/admin_linked_accounts/new" }.should route_to(:controller => "admin_linked_accounts", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/admin_linked_accounts/1" }.should route_to(:controller => "admin_linked_accounts", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/admin_linked_accounts/1/edit" }.should route_to(:controller => "admin_linked_accounts", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/admin_linked_accounts" }.should route_to(:controller => "admin_linked_accounts", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/admin_linked_accounts/1" }.should route_to(:controller => "admin_linked_accounts", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/admin_linked_accounts/1" }.should route_to(:controller => "admin_linked_accounts", :action => "destroy", :id => "1")
    end

  end
end
