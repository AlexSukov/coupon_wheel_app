Rails.application.routes.draw do
  resources :collected_emails
  resources :settings, only: :update
  resources :slices, except: [:index, :new]
  post 'clientside', to: 'settings#clientside'
  post 'add_url_filter/:id', to: 'settings#add_url_filter'
  post 'remove_url_filter/:id', to: 'settings#remove_url_filter'

  root to: 'home#index'
  mount ShopifyApp::Engine, at: '/'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
