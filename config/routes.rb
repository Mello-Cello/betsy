Rails.application.routes.draw do
  get "/merchants/current", to: "merchants#current", as: "current_merchant"
  get "homepages/index"
  resources :categories, only: [:new, :create, :index, :show]
  resources :items, only: [:create, :update, :destroy]
  resources :merchants, only: [:index, :create, :show]
  resources :orders # UPDATE THIS AFTER WE DECIDE WHAT WE NEED/DON'T

  get "/cart", to: "orders#view_cart", as: "cart"
  get "/cart/checkout", to: "orders#checkout", as: "checkout_cart"
  post "/cart", to: "orders#purchase", as: "purchase_cart"

  # Is this correct? -mf
  resources :categories do
    resources :products, only: [:index]
  end

  resources :products, except: [:destroy] do
    resources :reviews, only: [:create]
    resources :items, only: [:create]
  end

  root to: "homepages#index"
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "auth_callback"
  delete "/logout", to: "merchants#logout", as: "logout"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
