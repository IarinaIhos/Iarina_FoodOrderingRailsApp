Rails.application.routes.draw do
  namespace :admin do
    resources :products
    resources :users
    resources :orders, only: [:index, :show]
  end

  root to: "main#index"

  resources :users, only: [ :new, :create, :index ]
  resources :orders, only: [:index, :show, :create]

  delete "/logout", to: "session#destroy", as: :logout
  get "/login", to: "session#new", as: :login
  post "/session", to: "session#create"
  get "/session/success", to: "session#success", as: :session_success

  resources :carts, only: [ :index, :create, :destroy, :update ] do
    collection do
      delete :clear
    end
  end
end
