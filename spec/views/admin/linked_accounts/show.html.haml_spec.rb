require 'spec_helper'

describe "admin_linked_accounts/show.html.haml" do
  before(:each) do
    @linked_account = assign(:linked_account, stub_model(Admin::LinkedAccount,
      :service => "Service",
      :email => "Email",
      :service_id => "Service"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Service/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Email/)
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Service/)
  end
end
