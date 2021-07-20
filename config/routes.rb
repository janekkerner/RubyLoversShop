Rails.application.routes.draw do
  devise_for :admin_users, path: '/admin'
  devise_for :users
  get '/products', to: 'products#index'

  namespace :admin do
    get '/', to: 'dashboards#index'
    get '/dashboard', to: 'dashboards#index'
    resources :products
  end

  post '/', to: 'pages#home'
  root to: 'pages#home'

  get 'cart', to: 'shopping_cart#show', as: 'cart'
end
