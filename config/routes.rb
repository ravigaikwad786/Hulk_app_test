Rails.application.routes.draw do
  get "password_resets/new"
  get "password_resets/edit"
  root "static_pages#home"

  get "/help", to: "static_pages#help"
  get "/about", to: "static_pages#about"

  get "/signup", to: "users#new"

  get "/login", to: "session#new"
  post "/login", to: "session#create"
  delete "/logout", to: "session#destroy"

  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]

  resources :posts, only: [:create, :destroy]

  #get 'session/new'

  # get 'users/new'

  # # get 'static_pages/home'
  # get 'static_pages/help'
  #  get 'static_pages/about'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
