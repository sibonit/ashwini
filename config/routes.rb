Rails.application.routes.draw do

get 'news/index' => 'news#index', as: 'newslist'
get 'calendar/index'
get 'welcome/index'

#get 'alumni' => 'welcome#alumni', as: 'alumni'
#get 'alumni_2' => 'welcome#alumni_2', as: 'alumni_2'
#get 'resources' => 'welcome#resources', as: 'resources'
#get 'business_HR' => 'welcome#business_HR', as: 'business_HR'
#get 'business_purchasing' => 'welcome#business_purchasing', as: 'business_purchasing'
#get 'business_reimbursements' => 'welcome#business_reimbursements', as: 'business_reimbursements'
#get 'business_grants' => 'welcome#business_grants', as: 'business_grants'



#KA: Assign named routed to People pages

scope 'people', as: 'people' do
	resources :departments
end

scope 'people', as: 'people' do
	resources :research_areas
end

resources :people 


#resources :people, path: "people/admin"
#get 'people/faculty'  => 'people#faculty', as: 'faculty'


resources :courses do
  collection do
    get :special
    get :proficiency_exams
    end
end
#get 'courses/test'  => 'courses#test', as: 'test'


#KA: Resources for Admin pages
namespace :admin do
    resources :people
    resources :courses
   end

#resources :people, path: "/admin/people"


#get 'people/admin'  => 'people#admin#index', as: 'people_admin'
#get 'people/admin/new'  => 'people#admin#new', as: 'people_admin_new'
#get 'people/edit'  => 'people#edit', as: 'people_edit'
#get 'people/show'  => 'people#show', as: 'people_show'

#resources :admin


#=====================================================================================

# KA: Replace the above with named Route. THis route can be called using help_path
get 'static_pages/help' => 'static_pages#help', as: 'help'
 get 'static_pages/home' => 'static_pages#home', as: 'home'
get 'static_pages/about' => 'static_pages#about', as: 'about'
get 'static_pages/contact' => 'static_pages#contact', as: 'contact'
get 'signup'  => 'users#new'

get 'removed' => 'welcome#removed', as: 'removed'
get 'new_pages' => 'welcome#new_pages', as: 'new_pages'
get 'admin' => 'welcome#admin', as: 'admin'

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
