Rails.application.routes.draw do
  get 'products/index', to: 'products#index'
  root to: "pages#home"
end
