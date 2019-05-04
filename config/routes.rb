Rails.application.routes.draw do
  get "homepages/index"
  resources :categories, only: [:new, :create, :index, :show]
  resources :items, only: [:create, :update, :delete]
  resources :merchants, only: [:index, :create, :show, :delete]
  resources :orders # UPDATE THIS AFTER WE DECIDE WHAT WE NEED/DON'T

  # Is this correct? -mf
  resources :categories do
    resources :products, only: [:index]
  end

  # resources :categories, only: [:new, :create, :index]
  resources :products, except: [:delete] do
    resources :reviews, only: [:create]
  end

  root to: "homepages#index"
  # root "works#root"
  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "merchants#create", as: "auth_callback"
  delete "/logout", to: "merchants#logout", as: "logout"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
