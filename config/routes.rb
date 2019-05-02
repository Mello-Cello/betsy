Rails.application.routes.draw do
  resources :categories, only: [:new, :create, :index]
  resources :products, except: [:delete]
  resources :items, only: [:create, :update, :delete]
  resources :merchants, only: [:create, :show, :delete]
  resources :reviews, only: [:create]
  resources :orders # UPDATE THIS AFTER WE DECIDE WHAT WE NEED/DON'T

  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create"
  delete "/logout", to: "users#destroy", as: "logout"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
