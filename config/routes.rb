Rails.application.routes.draw do

get 'news/index' => 'news#index', as: 'newslist'
get 'calendar/index'
get 'welcome/index'

get 'alumni' => 'welcome#alumni', as: 'alumni'
get 'alumni_2' => 'welcome#alumni_2', as: 'alumni_2'

#KA: Assign named routed to About pages
get 'about'  => 'about#index', as: 'about_home'
get 'about/contact' => 'about#contact', as: 'about_contact'
get 'about/convocation' => 'about#convocation', as: 'about_convocation'
get 'about/departments' => 'about#departments', as: 'about_depts'
get 'about/faq' => 'about#faq', as: 'about_faq'
get 'about/whyib' => 'about#whyib', as: 'about_whyib'


#KA: Assign named routed to Ugrad pages
get 'undergraduate'  => 'ugrad#index', as: 'undergrad_home'
get 'ugrad/advising' => 'ugrad#advising', as: 'advising'
get 'ugrad/prospective' => 'ugrad#prospective', as: 'prospective'
get 'ugrad/options' => 'ugrad#options', as: 'options'
get 'ugrad/programs' => 'ugrad#programs', as: 'programs'
get 'ugrad/special_programs' => 'ugrad#special_programs', as: 'special_programs'
get 'ugrad/courses' => 'ugrad#courses', as: 'ugrad_courses'
get 'ugrad/honors' => 'ugrad#honors', as: 'ugrad_honors'


#KA: Assign named routed to Graduate pages
get 'graduate'  => 'graduate#index', as: 'grad_home'
get 'graduate/departments' => 'graduate#departments', as: 'grad_depts'
get 'graduate/grants' => 'graduate#grants', as: 'grad_grants'
get 'graduate/news' => 'graduate#news', as: 'grad_news'
get 'graduate/support' => 'graduate#support', as: 'grad_support'
get 'graduate/prospective' => 'graduate#prospective', as: 'grad_prospective'
get 'graduate/courses' => 'graduate#courses', as: 'grad_courses'


#KA: Assign named routed to People pages
get 'people'  => 'people#index', as: 'people_home'
get 'people/academics' => 'people#academics', as: 'people_academics'
get 'people/faculty' => 'people#faculty', as: 'people_faculty'
get 'people/faculty_interviews' => 'people#faculty_interviews', as: 'people_faculty_interviews'
get 'people/faculty_other' => 'people#faculty_other', as: 'people_faculty_other'
get 'people/grad_students' => 'people#grad_students', as: 'people_grad_students'
get 'people/staff' => 'people#staff', as: 'people_staff'


#=====================================================================================

# KA: Replace the above with named Route. THis route can be called using help_path
get 'static_pages/help' => 'static_pages#help', as: 'help'
 get 'static_pages/home' => 'static_pages#home', as: 'home'
get 'static_pages/about' => 'static_pages#about', as: 'about'
get 'static_pages/contact' => 'static_pages#contact', as: 'contact'
get 'signup'  => 'users#new'

get 'removed' => 'welcome#removed', as: 'removed'


#=================================================================================

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

  # route for 'static' content
  get '*path' => 'static#index'

end
