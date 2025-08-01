Rails.application.routes.draw do
  namespace :admin do
    resources :products
  end

  root to: "main#index"
  get "/about", to: "main#index"
  get "/service", to: "main#index"
  get "/blog", to: "main#index"
  get "/contacts", to: "main#index"
end