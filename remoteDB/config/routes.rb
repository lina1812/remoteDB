RemoteDB::Application.routes.draw do
  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
   root 'home#start'

  # Example of regular route:
	get 'shell/' => 'home#shell', as: 'shell_path'
	get 'text/' => 'home#text'
	post 'text/' => 'home#text'
	get 'user_control/' => 'home#user_control'
	post 'user_control/' => 'home#user_control'
	get 'user_control_no_db/' => 'home#user_control_no_db'
	post 'user_control_no_db/' => 'home#user_control_no_db'
	get 'start' => 'home#start', as: 'user_root'
	get 'bd_control/' =>'home#bd_control'
	post 'bd_control/' =>'home#bd_control'
	get 'a_search/' =>'home#a_search'
	post 'a_search/' =>'home#a_search'
	
  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
