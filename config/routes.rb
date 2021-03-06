Supremo::Application.routes.draw do
  resources :departments do
    member do
      get 'users','closed_tickets','new_tickets','assigned_tickets','reopened_tickets','resolved_tickets'
    end
  end

  resources :tickets do
    resources :comments
    member do
      post 'resolve'
      post 'close'
      post 'reopen'
    end

  end
  devise_for :users,:controllers => { :registrations => "registrations" } do
    get "/login" => "devise/sessions#new"
    get "/logout" => "devise/sessions#destroy"
    root :to => "devise/sessions#new"
  end

  resources :users do
    member do
     	get 'mydepartments'
      get 'change_password'
      put 'update_current_password'
     	get :upload_image
			put :save_uploaded_image
    end
  end


  resources :admins,:controller=>:users do
    member do
      get 'show_department'
      post 'assign_role'
    end
    collection do
      get 'users'
      get 'departments'
    end
  end


  resources :employees,:controller=>:users
  resources :engineers,:controller=>:users

  match 'tickets/:id/assign(/:user_id)',:to=>'tickets#assign',:as=>'assign_ticket'
  match 'tickets/:id/reassign(/:user_id)',:to=>'tickets#reassign',:as=>'reassign_ticket'
  match 'user/tickets/:status',:to=>'users#ticket_status',:as=>'mytickets'
  #match 'tickets/closed/:department_id',:to=>'tickets#closed',:as=>'closed_ticket'
  #match 'tickets/assigned/:department_id',:to=>'tickets#assigned',:as=>'assigned_ticket'




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
