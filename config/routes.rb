Snopsize::Application.routes.draw do

  # Devise user routes
  # Generates a bunch of routes for devise
  # Put these at the top so that they're evaluated first
  
  # Default routes
  # devise_for :users

  # Need to switch around the registration routes so that we can't delete users
  devise_for :users, skip: :registrations
  devise_scope :user do
    resource :registration,
    only: [:new, :create, :edit, :update], 
    path: 'users', 
    controller: 'devise/registrations',
    as: :user_registration
  end

  # general navigation
  match 'about' => 'general#about', :as => 'about', :via => :get
  # match 'help' => 'general#help', :as => 'help', :via => :get

  # Favouriting
  post "fave_snops/favourite"
  post "fave_snops/unfavourite"

  # for about page
  match 'about' => 'about#show', :as => 'about', :via => :get

  # for confirming from devise -- it puts you to /users, so instead of changing that
  # we'll just redirect
  match '/users' => redirect('/')

  # for user pages
  match 'users/:id' => 'users#show', :as => 'user', :via => :get
  # for user favourites
  match 'users/:id/favourites' => 'users#favourites', :as => 'user_favourites', :via => :get

  # for searching snops
  match 'search' => 'search#search', :as => 'search', :via => :get

  # for showing all resources from a given domain
  match 'domains/:id' => 'domains#show', :as => 'domain', :via => :get

  # for showing all snops from a given resource
  match 'domains/:domain_id/resources/:resource_id' => 'resources#show', :as => 'resource', :via => :get

  # all of the snop resources
  resources :snops, :except => [:index, :edit, :update] do
    member do
      get 'like'
    end
  end

  # all of our user categories
  resources :user_categories, :except => :show
	post "user_categories/set_snop"

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
