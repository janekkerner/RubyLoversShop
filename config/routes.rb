Rails.application.routes.draw do
  devise_for :admin_users, path: '/admin'
  devise_for :users, controllers: { registrations: 'users/registrations' }
  get '/products', to: 'products#index'
  resources :products

  namespace :admin do
    get '/', to: 'dashboards#index'
    get '/dashboard', to: 'dashboards#index'
    resources :products
  end

  post '/', to: 'pages#home'
  root to: 'pages#home'

  get 'cart', to: 'shopping_cart#show', as: 'cart'
  post 'cart/:id', to: 'shopping_cart#add_product_to_cart', as: 'add_product_to_cart'
end
