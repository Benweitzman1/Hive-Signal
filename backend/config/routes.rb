Rails.application.routes.draw do
  devise_for :users
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    post 'auth/register', to: 'auth#register'
    post 'auth/login', to: 'auth#login'
    post 'auth/logout', to: 'auth#logout'
    get 'auth/current_user', to: 'auth#current_user_info'
    resources :messages, only: [:index, :create]
  end
end
