class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    @game = Game.all

    if(current_user != @user)
      redirect_to root_path, alert: "You are not allowed to view other player's profiles." and return
    end
  end

end
