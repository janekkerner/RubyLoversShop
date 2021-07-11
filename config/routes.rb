Rails.application.routes.draw do
  get 'shopping_cart/show'
  devise_for :admin_users, path: '/admin'
  devise_for :users
  get '/products', to: 'products#index'

  namespace :admin do
    get '/', to: 'dashboards#index'
    get '/dashboard', to: 'dashboards#index'
    resources :products
  end
  
  post '/', to: 'pages#home'
  root to: "pages#home"
end
