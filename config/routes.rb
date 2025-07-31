require 'sidekiq/web' if Rails.env.development?
Rails.application.routes.draw do
  root to: 'home#index'
  mount Sidekiq::Web => '/sidekiq' if Rails.env.development?

  resources :sessions, only: [:new, :create, :destroy]
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  get 'auth/:provider/callback', to: 'admin/home#xero'
  get 'auth/xero_oauth2/callback', to: 'admin/home#index'

  get 'careers', to: 'careers#index'
  get 'contacts', to: 'contacts#index'
  get 'menu', to: 'menu#index'
  get 'products', to: 'products#index'
  get 'visit', to: 'visit#index'

  namespace :admin do
    get '/', to: 'home#index'
    get 'fulfillment', to: 'fulfillment#index'
    get 'delivery_route', to: 'delivery_route#index'
    post 'delivery_route', to: 'delivery_route#show'
    resources :contacts do
      member do
        get :undestroy
        get :repeat_last_order
      end
    end
    resources :notes do
      member do
        get 'close'
        patch 'resolve'
      end
    end
    resources :orders do
      member do
        get 'fulfill'
        get 'unfulfill'
        get 'invoice'
      end
    end
    resources :products
    resources :sales_reps
    resources :states
    resources :towns
    resources :users

    get 'reports', to: 'reports#index'
    get 'reports/kegs', to: 'reports#kegs'
    get 'reports/orders', to: 'reports#orders'
  end

  namespace :customer do
    get '/', to: 'home#index'
    get '/signup', to: 'signup#new'
    post '/signup', to: 'signup#create'
    get '/orders/:id', to: 'orders#show', as: 'order'
  end
end
