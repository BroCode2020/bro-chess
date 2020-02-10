Rails.application.routes.draw do
  resources :games
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }
  get 'games/:id/:piece_id/:x_coord/:y_coord', :to => 'games#select', :as => 'select'
  post 'games/:id/:piece_id/:x_coord/:y_coord', :to => 'games#move', :as => 'move'

  root 'static_pages#index'

end
