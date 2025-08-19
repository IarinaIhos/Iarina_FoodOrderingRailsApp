Rails.application.routes.draw do
  devise_for :users
  namespace :admin do
    resources :products
    resources :users
    resources :orders, only: [:index, :show]
  end

  # API routes
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :show]
    end
  end

  root to: "main#index"

  resources :users, only: [ :index ]
  resources :orders, only: [ :index, :show, :create ]

  resources :carts, only: [ :index, :create, :destroy, :update ] do
    collection do
      delete :clear
    end
  end
end
