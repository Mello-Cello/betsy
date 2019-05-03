Rails.application.routes.draw do
  resources :categories, only: [:new, :create, :index, :show]
  resources :products, except: [:delete]
  resources :items, only: [:create, :update, :delete]
  resources :merchants, only: [:index, :create, :show, :delete]
  resources :reviews, only: [:create]
  resources :orders # UPDATE THIS AFTER WE DECIDE WHAT WE NEED/DON'T

  # Is this correct? -mf
  resources :categories do
    resources :products, only: [:index]
  end

  get "/auth/github", as: "github_login"
  get "/auth/:provider/callback", to: "users#create"
  delete "/logout", to: "users#destroy", as: "logout"

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
