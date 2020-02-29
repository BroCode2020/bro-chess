Rails.application.routes.draw do
  resources :games
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  post 'games/:id/:piece_id/:x_pos/:y_pos', :to => 'games#move', :as => 'move'
  post 'game/:id/', :to => 'games#forfeit', :as => 'forfeit'

  root 'static_pages#index'
  resources :games, only: %i[new index create show update] do
    member do
      get :game_available
     #patch :join_as_black, :join_as_white
     put :join_as_black, :join_as_white
    end

   end
 end
