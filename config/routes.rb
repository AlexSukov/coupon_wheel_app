Rails.application.routes.draw do
  resources :collected_emails
  resources :settings
  resources :slices
  root :to => 'home#index'
  mount ShopifyApp::Engine, at: '/'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
