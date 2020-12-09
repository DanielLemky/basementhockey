Rails.application.routes.draw do

  devise_for :users, :controllers => {
    registrations: 'registrations'
  }

  root :to => 'dashboard#index'

  resources :seasons
  resources :games do
    resources :results
  end

end
