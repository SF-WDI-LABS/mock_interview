Rails.application.routes.draw do

  root "posts#index"

  resources :posts do
    resources :comments, except: [:index, :show]
  end

  get "/signup", to: "users#new"
  get "/login", to: "sessions#new"
  get "/logout", to: "sessions#destroy"
  
  resources :users, except: [:new]
  resources :sessions, only: [:create]

end