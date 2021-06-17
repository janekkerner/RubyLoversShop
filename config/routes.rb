Rails.application.routes.draw do
  devise_for :admins
  devise_for :users
  get '/products', to: 'products#index'
  post '/', to: 'pages#home'
  root to: "pages#home"
end
