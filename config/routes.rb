Rails.application.routes.draw do
  devise_for :admin_users, path: '/admin'
  devise_for :users
  get '/products', to: 'products#index'

  namespace :admin do
    get '/', to: 'dashboards#index'
  end
  post '/', to: 'pages#home'
  root to: "pages#home"
end
