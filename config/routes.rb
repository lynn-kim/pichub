Rails.application.routes.draw do
  resources :carts
  resources :images
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "images#index"
  delete '/destroy_all', to: 'images#destroy_all'
  patch '/add_to_cart/:image_id', to: 'carts#add_image'
end
