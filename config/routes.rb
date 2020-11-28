Rails.application.routes.draw do
  root to: 'users#index'

  resources :users

  get 'show' => 'users#show'
end
