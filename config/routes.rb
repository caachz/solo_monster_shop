Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html



  get "/", to: "welcome#index"
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  scope module: :visitors do
    get '/register', to: "users#new"
    post '/users', to: "users#create"
  end

  scope module: :users do
    # resource :profile, only: [:update]
    get '/profile', to: 'users#show'
    get '/profile/edit', to: 'users#edit'
    get '/profile/edit/password', to: 'users#change_password'
    patch '/users', to: 'users#update'

    scope :profile do
      resources :orders, only: [:index, :show, :update]
    end
  end

  namespace :merchant do
    get '/', to: 'merchant#show'
    resources :orders, only: [:show]
    resources :items, only: [:index, :update, :destroy]
    resources :discounts, only:[:index, :new, :create, :update, :edit]
  end

  namespace :admin do
    get '/', to: 'admin#show'
    get '/users', to: 'users#index'
    get '/users/:id', to: 'users#show'
    resources :merchants, only: [:index, :show, :update]
    resources :orders, only: [:update]
  end

  # TO BE NAMESPACED
  get "/merchants", to: "merchants#index"
  get "/merchants/new", to: "merchants#new"
  get "/merchants/:id", to: "merchants#show"
  post "/merchants", to: "merchants#create"
  get "/merchants/:id/edit", to: "merchants#edit"
  patch "/merchants/:id", to: "merchants#update"
  delete "/merchants/:id", to: "merchants#destroy"

  get "/items", to: "items#index"
  get "/items/:id", to: "items#show"
  get "/items/:id/edit", to: "items#edit"
  patch "/items/:id", to: "items#update"
  get "/merchants/:merchant_id/items", to: "items#index"
  get "/merchants/:merchant_id/items/new", to: "items#new"
  post "/merchants/:merchant_id/items", to: "items#create"
  delete "/items/:id", to: "items#destroy"

  get "/items/:item_id/reviews/new", to: "reviews#new"
  post "/items/:item_id/reviews", to: "reviews#create"

  get "/reviews/:id/edit", to: "reviews#edit"
  patch "/reviews/:id", to: "reviews#update"
  delete "/reviews/:id", to: "reviews#destroy"

  post "/cart/:item_id", to: "cart#add_item"
  get "/cart", to: "cart#show"
  patch "/cart/:item_id", to: "cart#increment_decrement"
  delete "/cart", to: "cart#empty"
  delete "/cart/:item_id", to: "cart#remove_item"

  get "/orders/new", to: "orders#new"
  post "/orders", to: "orders#create"
  get "/orders/:id", to: "orders#show"

  resources :item_orders, only: [:update]
end
