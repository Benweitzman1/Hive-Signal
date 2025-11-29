Rails.application.routes.draw do
  devise_for :users
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    resources :messages, only: [:index, :create]
  end
end
