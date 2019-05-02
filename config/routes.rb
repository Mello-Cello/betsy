Rails.application.routes.draw do
  get 'categories/new'
  get 'categories/create'
  get 'categories/index'
  get 'products/new'
  get 'products/create'
  get 'products/index'
  get 'products/show'
  get 'products/edit'
  get 'products/update'
  get 'items/create'
  get 'items/update'
  get 'items/delete'
  get 'merchants/create'
  get 'merchants/show'
  get 'merchants/delete'
  get 'reviews/create'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
