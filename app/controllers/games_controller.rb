class GamesController < ApplicationController

  def index
    @available_games = Game.available
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.create(game_params)
     redirect_to game_path(@game.id)
  end

  def show
    @game = Game.find(params[:id])
  end

def update
  @game = Game.find(params[:id])
  return render_not_found if @game.nil?
  @game.update_attributes(game_params)
  redirect_to game_path(@game.id)
end

def join_as_black
  @game = Game.find(params[:id])
  return render_not_found if @game.nil?
  @game.update_attribute(:black_player_id, current_user.id)
  redirect_to game_path(@game.id)
end

def join_as_white
  @game = Game.find(params[:id])
  return render_not_found if @game.nil?
  @game.update_attribute(:white_player_id, current_user.id)
  redirect_to game_path(@game.id)
end

  def game_available
    return render plain: 'true' if !current_game.white_player_id || !current_game.black_player_id
    render plain: 'false'
end

  private

  def game_params
    params.require(:game).permit(:name, :black_player_id, :white_player_id)
  end

end
