Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :actors, only: [:show] do
    resources :movies, only: [:index]
  end

  resources :movies, only: [:show] do
    resources :actors, only: [:index]
  end

  resources :game, only: [:show, :create]
end
