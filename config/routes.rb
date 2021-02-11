Rails.application.routes.draw do
  resources :answers
  resources :options
  resources :polls
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
