Rails.application.routes.draw do
  get 'products/index'
  root to: "pages#home"
end
