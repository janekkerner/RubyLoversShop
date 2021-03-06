Rails.application.routes.draw do
  devise_for :admin_users, path: '/admin'
  devise_for :users
  get '/products', to: 'products#index'
  resources :products

  namespace :admin do
    get '/', to: 'dashboards#index'
    get '/dashboard', to: 'dashboards#index'
    resources :orders, only: [:index, :show, :update]
    resources :products
    resources :payments, only: [:update]
    resources :shipments, only: [:update]
  end

  post '/', to: 'pages#home'
  root to: 'pages#home'

  get 'cart', to: 'shopping_cart#show', as: 'cart'
  post 'cart/:id', to: 'shopping_cart#add_product_to_cart', as: 'add_product_to_cart'
  delete 'cart', to: 'shopping_cart#destroy_cart_items', as: 'clear_shopping_cart'

  get 'checkout', to: 'checkouts#show', as: 'checkout'
  post 'checkout', to: 'checkouts#create', as: 'create_checkout'
end
