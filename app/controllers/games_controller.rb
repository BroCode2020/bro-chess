class GamesController < ApplicationController
  def index
  end

  def new
    @game = Game.new
  end

  def create
  end

  def show
  end

  private

  def game_params
    params.require(:game).permit(:name)
  end

end
