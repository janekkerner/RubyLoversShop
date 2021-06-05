Rails.application.routes.draw do
  get '/products', to: 'products#index'
  root to: "pages#home", as: "home"
end
