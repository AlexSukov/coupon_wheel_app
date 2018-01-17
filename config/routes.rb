Rails.application.routes.draw do
  resources :collected_emails
  resources :settings, only: :update
  resources :slices, except: [:index, :new]
  post 'clientside', to: 'settings#clientside' 
  root to: 'home#index'
  mount ShopifyApp::Engine, at: '/'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
