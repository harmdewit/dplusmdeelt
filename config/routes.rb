Dplusm::Application.routes.draw do
  

  devise_for :admins

  match '/auth/:provider/callback' => 'admin/linked_accounts#create'
  
  namespace :admin do
    resources :pages
    resources :linked_accounts do
      collection do
        post 'synchronize', :as => :synchronize
      end
      resources :facebook_pages, :only => [:new, :create]
    end
    root :to => 'linked_accounts#index'
  end

  resources :magazine, :only => :index
  get 'magazine/:year/:month' => 'magazine#archive', :as => :magazine
  get 'magazine/posts/tumblr/:id' => 'magazine#tumblr_post', :as => :tumblr_post
  get 'magazin/page/:id' => 'magazine#page', :as => :magazine_page
  get "magazine/frontpage"
  get "magazine/images"
  get "magazine/images_alternative"
  
  post 'magazine/hide_page/:id/:page_hash'     => 'magazine#hide_page',    :as => :hide_page
  post 'magazine/rebuild_page/:id/:page_hash'  => 'magazine#rebuild_page', :as => :rebuild_page
  
  resources :articles, :only => :show
  resources :pages

  get "test/index"

  root :to => 'magazine#index'
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
