Rails.application.routes.draw do
  root to: 'home#index'

  resources :sessions, only: [:new, :create, :destroy]
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'

  # get 'careers', to: 'careers#index'
  get 'contacts', to: 'contacts#index'
  get 'products', to: 'products#index'
  get 'visit', to: 'visit#index'

  namespace :admin do
    get '/', to: 'home#index'
    resources :contacts do
      member do
        get :undestroy
      end
    end
    resources :notes
    resources :products
    resources :states
    resources :towns
    resources :users
  end
end
