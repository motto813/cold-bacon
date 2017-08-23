Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :actors, only: [:show] do
    resources :movies, only: [:index]
  end

  resources :movies, only: [:show] do
    resources :actors, only: [:index]
  end

  resources :games, only: [:show, :create] do
    resources :paths, only: [:index, :create]
  end

  resources :paths, only: [:show]

  post '/games/create_demo', to: 'games#create_demo'
end
