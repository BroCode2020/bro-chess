Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  root 'static_pages#index'
  resources :games, only: %i[new index create show update] do
    member do
      get :game_available
     #patch :join_as_black, :join_as_white
     put :join_as_black, :join_as_white
    end
   end
 end
