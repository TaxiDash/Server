TaxiRatingServer::Application.routes.draw do
  devise_for :users, :controllers => { :registrations => "users/registrations" }, skip: [:registrations]
  root 'static_pages#overview'

  #Static Pages
  get 'static_pages/help'
  get 'overview' => 'static_pages#overview', :as => 'overview'
  get 'about' => 'static_pages#about', :as => 'about'
  get 'static_pages/import_export', :as => 'import_export'
  get 'get_best_worst/:time&:sort_dir&:length' => 'static_pages#get_ratings'
  get 'get_hist_companies/' => 'static_pages#get_historical_company_ratings'

  #Driver stuff
  resources :drivers
  get 'mobile/:beacon_id' => 'drivers#show'
  get 'mobile/images/drivers/:beacon_id' => 'drivers#get_image'
  get 'drivers/:id' => 'drivers#show', :as => 'show_driver'
  get 'drivers/documents/new/:driver_id' => 'documents#new', :as => 'attach_doc'
  get 'drivers_download' => 'drivers#download', :as => 'download_drivers'
  post 'drivers_import' => 'drivers#import', :as => 'import_drivers'

  #Users
  resources :users
  get 'users/:id' => 'users#show', :as => 'show_user'
  get 'users/modify/:id' => 'users#edit', :as => 'edit_other_user'#Edit users as admin
  get 'users_download' => 'users#download', :as => 'download_users'
  post 'users_import' => 'users#import', :as => 'import_users'

  #Company stuff
  resources :companies
  get 'companies/:id' => 'companies#show', :as => 'show_company'
  get 'companies/recalc/:id' => 'companies#recalculate_average', :as => 'recalc_company'
  get 'mobile/images/companies/:id' => 'companies#get_image'
  get 'companies_download' => 'companies#download', :as => 'download_companies'
  post 'companies_import' => 'companies#import', :as => 'import_companies'

  #Documents
  resources :documents
  get 'documents/:id' => 'documents#show', :as => 'show_document'
  get 'documents/view/:id' => 'documents#view', :as => 'view_document'
  get 'documents_download' => 'documents#download', :as => 'download_documents'
  post 'documents_import' => 'documents#import', :as => 'import_documents'

  #Ratings
  resources :ratings
  get 'ratings/:id' => 'ratings#show', :as => 'show_rating'
  get 'ratings_download' => 'ratings#download', :as => 'download_ratings'
  post 'ratings_import' => 'ratings#import', :as => 'import_ratings'

  #Riders
  resources :riders
  get 'riders/:id' => 'riders#show', :as => 'show_rider'
  get 'riders_download' => 'riders#download', :as => 'download_riders'
  post 'riders_import' => 'riders#import', :as => 'import_riders'

  #Rides
  resources :rides
  get 'rides/:id' => 'rides#show', :as => 'show_ride'
  get 'rides_download' => 'rides#download', :as => 'download_rides'
  post 'rides_import' => 'rides#import', :as => 'import_rides'

  #Manual
  get "manual/overview", :as => "manual"
  get "manual/add_company", :as => "man_add_company"
  get "manual/add_driver", :as => "man_add_driver"
  get "manual/rate", :as => "man_rate"
  get "manual/check_rating", :as => "man_check_rating"
  get "manual/get_stats", :as => "man_get_stats"
  get "manual/faq", :as => "man_faq"
  #get 'users/new/' => 'users/sign_up'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
