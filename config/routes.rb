Rails.application.routes.draw do


get 'posts/index' => 'posts#index', as: 'postslist'

get 'news/index' => 'news#index', as: 'newslist'

  get 'calendar/index'



get 'ugrad/advising' => 'ugrad#advising', as: 'advising'
get 'ugrad/prospective' => 'ugrad#prospective', as: 'prospective'
get 'ugrad/options' => 'ugrad#options', as: 'options'
get 'ugrad/programs' => 'ugrad#programs', as: 'programs'
get 'ugrad/special_programs' => 'ugrad#special_programs', as: 'special_programs'



# KA: Replace the above with named Route. THis route can be called using help_path

# KA:Routes for sample layout pages
get 'sample_layouts/onecolumn' => 'sample_layouts#onecolumn', as: 'onecolumn'
get 'sample_layouts/twocolumneven' => 'sample_layouts#twocolumneven', as: 'twocolumneven'
get 'sample_layouts/twocolumnuneven' => 'sample_layouts#twocolumnuneven', as: 'twocolumnuneven'
get 'sample_layouts/threecolumneven' => 'sample_layouts#threecolumneven', as: 'threecolumneven'
get 'sample_layouts/threecolumnpanel' => 'sample_layouts#threecolumnpanel', as: 'threecolumnpanel'
get 'sample_layouts/fourcolumneven' => 'sample_layouts#fourcolumneven', as: 'fourcolumneven'

get 'sample_layouts/secondlevel' => 'sample_layouts#secondlevel', as: 'secondlevel'
get 'sample_layouts/test' => 'sample_layouts#test', as: 'test'
get 'sample_layouts/ugrad' => 'sample_layouts#ugrad', as: 'ugrad'


get 'sample_layouts/tab' => 'sample_layouts#tab', as: 'tab'
#get 'sample_layouts/newslist' => 'sample_layouts#newslist', as: 'newslist'
get 'sample_layouts/newsitem' => 'sample_layouts#newsitem', as: 'newsitem'
get 'sample_layouts/leftsidebar' => 'sample_layouts#leftsidebar', as: 'leftsidebar'
get 'sample_layouts/contact' => 'sample_layouts#contact', as: 'samplecontact'
#==================
 

# get 'static_pages/help'
# KA: Replace the above with named Route. THis route can be called using help_path
get 'static_pages/help' => 'static_pages#help', as: 'help'
 get 'static_pages/home' => 'static_pages#home', as: 'home'
get 'static_pages/about' => 'static_pages#about', as: 'about'
get 'static_pages/contact' => 'static_pages#contact', as: 'contact'



get 'signup'  => 'users#new'

resources :users
  get 'articles/new'

  get 'welcome/index'

  resources :articles do
    resources :comments
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
   root 'welcome#index'
#    root 'static_pages#home'

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
