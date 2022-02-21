Rails.application.routes.draw do
  # devise_for :users
  devise_for :users
  root to: 'pages#home'
  resources :profiles, only: [:index, :show, :new, :edit, :update] do
    resources :notes, only: [:new, :create, :show, :index]
  end
  resources :loans, only: [:new, :create, :show, :index] do
    resources :loanees, only: [:new, :create]
  end
  resources :loanees, only: [:show, :edit, :update] do
    resources :weekly_payments, only: [:new, :create, :index, :edit, :update]
  end
  resources :users, only: [:new, :index, :show]
  resources :weekly_payments, only: [:edit, :update]
  post 'user_profile', to: "users#create", as: 'user_profile'
end
