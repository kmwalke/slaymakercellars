Rails.application.routes.draw do
  root to: 'home#index'

  resources :sessions, only: [:new, :create, :destroy]
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  get 'products', to: 'products#index'

  namespace :admin do
    get '/', to: 'home#index'
    resources :contacts do
      member do
        get :undestroy
      end
    end
    resources :users
  end
end
