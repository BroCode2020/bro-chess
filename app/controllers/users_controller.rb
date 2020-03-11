class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @game = Game.all
  end

end
