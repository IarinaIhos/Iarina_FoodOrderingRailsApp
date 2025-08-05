Rails.application.routes.draw do
  namespace :admin do
    resources :products
  end

  root to: "main#index"

  resources :users, only: [ :new, :create, :index ]
  delete "/logout", to: "sessions#destroy", as: :logout
  get "/login", to: "session#new", as: :login
  post "/session", to: "session#create"
  get "/session/success", to: "session#success", as: :session_success
  resources :products, only: [ :index ]
end
