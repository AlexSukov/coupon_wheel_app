Rails.application.routes.draw do
  resources :collected_emails, only: [:create, :destroy]
  resources :settings, only: :update
  resources :slices, only: [:create, :update, :destroy]
  post 'clientside', to: 'settings#clientside'
  post 'add_url_filter/:id', to: 'settings#add_url_filter'
  delete 'remove_url_filter/:id', to: 'settings#remove_url_filter'

  root to: 'home#index'
  mount ShopifyApp::Engine, at: '/'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
