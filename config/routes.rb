Rails.application.routes.draw do

  devise_for :users, :controllers => {
    registrations: 'registrations'
  }

  root :to => 'dashboard#index'

  resources :seasons do
    get :standings, as: :standings
    get :new_user
    post :add_user
    get "/games/my", as: :my_games
    resources :games, only: [:new, :index, :create]
  end

  resources :games, except: [:new, :index, :create] do
    resource :result
    resource :game_time
  end

end
