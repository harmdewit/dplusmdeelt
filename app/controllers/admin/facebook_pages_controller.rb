class Admin::FacebookPagesController < Admin::ApplicationController
  def new
    @linked_account = Admin::LinkedAccount.find(params[:linked_account_id])
    @facebook_page = FacebookPage.new

    @facebook_pages = session[:facebook_pages]
  end

  def create
    linked_account = Admin::LinkedAccount.find(params[:linked_account_id])
    
    uri = URI.parse(URI.encode("https://graph.facebook.com/#{params[:facebook_page][:uid]}?access_token=#{params[:facebook_page][:token]}"))
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.request_uri)
    response = http.request(request)
    response_hash = ActiveSupport::JSON.decode(response.body)
    picture = response_hash['picture']
    
    @facebook_page = FacebookPage.find_or_create_by_uid_and_name(
      :linked_account_id => linked_account.id,
      :provider => 'facebook',
      :uid => response_hash['id'], 
      :name => response_hash['name'],
      :nickname => response_hash['name'],
      :description => response_hash['category'],
      :image => response_hash['picture'],
      :urls => response_hash['link'],
      :token => params[:facebook_page][:token]
    )
    flash[:notice] = "Succesfully authenticated Facebook page #{@facebook_page.name}."
    redirect_to admin_linked_accounts_path

  end

end
