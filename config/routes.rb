Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :actors, only: [:show]

  resources :movies, only: [:show]

  resources :games, only: [:show, :create] do
    resources :paths, only: [:index, :create]
  end

  resources :actors, only: [:show] do
    resources :movies, only: [:index]
  end

  resources :movies, only: [:show]
  resources :paths, only: [:show]

  post '/create_demo/:starting_tmdb/:ending_tmdb', to: 'games#create_demo'

  get '/actors/:actor_id/known_for_movies', to: 'movies#known_for_movies'
end
