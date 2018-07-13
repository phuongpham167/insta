Rails.application.routes.draw do

  resources :post_attachments
  resources :posts do
    member do
      get :post_like, :post_bookmark
    end
  end
  get "sessions/new"
  root "static_pages#home"
  get "/help", to: "static_pages#help"
  get "/about", to: "static_pages#about"
  get "/contact", to: "static_pages#contact"
  get "/signup", to: "users#new"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resources :users do
    member do
      get :user_like, :following, :followers, :user_bookmark
    end
  end
  resources :albums
  resources :likes, only: [:create, :destroy]
  resources :bookmarks, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  resources :post_comments
  resources :notifications
end
