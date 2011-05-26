require 'net/http'
require "net/https"
require 'hashie'

class Admin::LinkedAccountsController < Admin::ApplicationController
  # GET /admin/linked_accounts
  # GET /admin/linked_accounts.xml
  def index
    @linked_accounts = Admin::LinkedAccount.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @linked_accounts }
    end
  end

  # GET /admin/linked_accounts/1
  # GET /admin/linked_accounts/1.xml
  def show
    @linked_account = Admin::LinkedAccount.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @linked_account }
    end
  end

  # GET /admin/linked_accounts/new
  # GET /admin/linked_accounts/new.xml
  def new
    @linked_account = Admin::LinkedAccount.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @linked_account }
    end
  end

  # GET /admin/linked_accounts/1/edit
  def edit
    @linked_account = Admin::LinkedAccount.find(params[:id])
  end

  # POST /admin/linked_accounts
  # POST /admin/linked_accounts.xml
  def create
    omniauth = request.env["omniauth.auth"]
    
    
    @linked_account = LinkedAccount.find_or_create_by_uid_and_provider(omniauth['uid'], omniauth['provider']) do |l|
      l.provider = omniauth['provider']
      l.uid = omniauth['uid']
      ui = omniauth['user_info']
        l.name = ui['name']
        l.email = ui['email']
        l.nickname = ui['nickname']
        l.first_name = ui['first_name']
        l.last_name = ui['last_name']
        l.location = ui['location']
        l.description = ui['description']
        l.image = ui['image']
        l.phone = ui['phone']
        l.urls = ui['urls']
      l.token = omniauth['credentials']['token']
      l.secret = omniauth['credentials']['secret']
    end
    
    unless omniauth['provider'] == 'facebook'
      redirect_to([:admin, @linked_account], :notice => 'Linked account was successfully created.') 
    else
       uri = URI.parse(URI.encode("https://graph.facebook.com/#{omniauth['uid']}/accounts?access_token=#{omniauth['credentials']['token']}"))
       http = Net::HTTP.new(uri.host, uri.port)
       http.use_ssl = true
       http.verify_mode = OpenSSL::SSL::VERIFY_NONE
       request = Net::HTTP::Get.new(uri.request_uri)
       response = http.request(request)
       response_hash = ActiveSupport::JSON.decode(response.body)
       
       @facebook_pages = []
       response_hash['data'].each do |rh|
         facebook_page = @linked_account.facebook_pages.build do |fp|
           fp.uid = rh['id']
           fp.name = rh['name']
           fp.description = rh['category']
           fp.token = rh['access_token']
         end
         @facebook_pages << facebook_page
       end
       redirect_to new_admin_linked_account_facebook_page_url @linked_account
       session[:facebook_pages] = @facebook_pages
     end

  end

  # PUT /admin/linked_accounts/1
  # PUT /admin/linked_accounts/1.xml
  def update
    @linked_account = Admin::LinkedAccount.find(params[:id])

    respond_to do |format|
      if @linked_account.update_attributes(params[:linked_account])
        format.html { redirect_to([:admin, @linked_account], :notice => 'Linked account was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @linked_account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin/linked_accounts/1
  # DELETE /admin/linked_accounts/1.xml
  def destroy
    @linked_account = Admin::LinkedAccount.find(params[:id])
    @linked_account.destroy

    respond_to do |format|
      format.html { redirect_to(admin_linked_accounts_url) }
      format.xml  { head :ok }
    end
  end
  
  def modify_hash_keys(data)
    case data
    when Hash
      data.inject({}) do |h,(k,v)|
        h[(k.respond_to?(:tr) ? k.tr('-', '_') : k)] = modify_hash_keys(v)
        h
      end
    when Array
      data.map { |i| modify_hash_keys(i) }
    else
      data
    end
  end
end
