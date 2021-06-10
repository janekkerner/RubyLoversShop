Rails.application.routes.draw do
  get '/products', to: 'products#index'
  post '/', to: 'pages#home'
  root to: "pages#home"
end
