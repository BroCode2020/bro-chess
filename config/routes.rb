Rails.application.routes.draw do
  devise_for :users
  post 'games/:id/:piece_id/:x_pos/:y_pos', :to => 'games#move', :as => 'move'
  post 'game/:id/forfeit', :to => 'games#forfeit', :as => 'forfeit'
  get 'game/:id/stalemate', :to => 'games#stalemate', :as => 'stalemate'
  get 'game/:id/checkmate', :to => 'games#checkmate', :as => 'checkmate'

  root 'static_pages#index'
  resources :games, only: %i[new index create show update] do
    member do
      get :game_available
     #patch :join_as_black, :join_as_white
     put :join_as_black, :join_as_white
    end
  end

  resources :users, only: :show

 end
