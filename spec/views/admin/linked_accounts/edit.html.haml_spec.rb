require 'spec_helper'

describe "admin_linked_accounts/edit.html.haml" do
  before(:each) do
    @linked_account = assign(:linked_account, stub_model(Admin::LinkedAccount,
      :service => "MyString",
      :email => "MyString",
      :service_id => "MyString"
    ))
  end

  it "renders the edit linked_account form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => admin_linked_accounts_path(@linked_account), :method => "post" do
      assert_select "input#linked_account_service", :name => "linked_account[service]"
      assert_select "input#linked_account_email", :name => "linked_account[email]"
      assert_select "input#linked_account_service_id", :name => "linked_account[service_id]"
    end
  end
end
