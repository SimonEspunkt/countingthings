Rails.application.routes.draw do
  root 'site#index'

  #DELETE
  get 'invitations/debug' => 'invitations#index'

  get 'things/:id/invite/' => 'invitations#new', as: :new_invitation, constraints: { id: /[0-9]+/, format: 'html'}
  post 'things/:id/invite/create' => 'invitations#create', constraints: { id: /[0-9]+/, format: 'html'}
  get  'vi/:code' => 'invitations#validateInvitation', as: :validate_invitation, constraints: { code: /[A-Za-z0-9\+\/\=\-]+/, format: 'html'}
  delete 'things/:thing_id/events/destroy' => 'events#destroy', as: :thing_event, constraints: { id: /[0-9]+/, format: 'html'}
  

  resources :things, constraints: { id: /[0-9]+/, format: 'html'} do
    resources :events, only: [:create], constraints: { id: /[0-9]+/, format: 'json'}
    member do
      get 'statistic', constraints: { id: /[0-9]+/, format: 'json'}
    end
  end


  devise_for :users
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

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
