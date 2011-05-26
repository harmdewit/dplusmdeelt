require 'spec_helper'

describe "admin_linked_accounts/index.html.haml" do
  before(:each) do
    assign(:admin_linked_accounts, [
      stub_model(Admin::LinkedAccount,
        :service => "Service",
        :email => "Email",
        :service_id => "Service"
      ),
      stub_model(Admin::LinkedAccount,
        :service => "Service",
        :email => "Email",
        :service_id => "Service"
      )
    ])
  end

  it "renders a list of admin_linked_accounts" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Service".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Service".to_s, :count => 2
  end
end
