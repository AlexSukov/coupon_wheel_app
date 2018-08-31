Rails.application.routes.draw do
  resources :collected_emails, only: [:create, :destroy]
  resources :settings, only: :update
  resources :slices, only: [:create, :update, :destroy]

  post 'clientside', to: 'settings#clientside'

  post 'mailchimp_api_key_verification', to: 'settings#mailchimp_api_key_verification'
  post 'klaviyo_api_key_verification', to: 'settings#klaviyo_api_key_verification'

  post 'add_url_filter/:id', to: 'settings#add_url_filter'
  delete 'remove_url_filter/:id', to: 'settings#remove_url_filter'

  post 'create_discount_code', to: 'home#create_discount_code'
  delete 'destroy_discount_code/:id', to: 'home#destroy_discount_code'

  get 'activatecharge', to: 'home#activatecharge'

  get 'collected_emails_pagination', to: 'home#collected_emails_pagination'

  post 'customers_redact', to: 'gdpr_webhooks#customers_redact'
  post 'shop_redact', to: 'gdpr_webhooks#shop_redact'

  root to: 'home#index'
  mount ShopifyApp::Engine, at: '/'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  require 'sidekiq/web'
  require 'admin_constraint'
  Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]
  mount Sidekiq::Web => '/sidekiq'
end
