Snopsize::Application.routes.draw do

  post "fave_snops/favourite"

  post "fave_snops/unfavourite"

  # for user pages
  match 'users/:id' => 'users#show', :as => 'users_show', :via => :get

  # for searching snops
  match 'search' => 'search#search', :as => 'search', :via => :get

  # for showing all resources from a given domain
  match 'domains/:domain_id' => 'domains#show', :as => 'domains_show', :via => :get

  # for showing all snops from a given resource
  match 'domains/:domain_id/resources/:resource_id' => 'resources#show', :as => 'resources_show', :via => :get

  # all of the snop resources
  resources :snops, :except => [:edit, :update]

  # all of our user categories
  resources :user_categories, :except => [:show]

  get 'home/index'

  devise_for :users, :skip => [:sessions]
  as :user do
    get 'signin' => 'devise/sessions#new', :as => :new_user_session
    post 'signin' => 'devise/sessions#create', :as => :user_session
    delete 'signout' => 'devise/sessions#destroy', :as => :destroy_user_session
    get 'signup' => 'devise/registrations#new', :as => :new_user_registration
  end

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
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
