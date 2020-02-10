class GamesController < ApplicationController
  def index
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.create(game_params)
    redirect_to root_path
  end

  def show
    @game = Game.find(params[:id])
  end

  def select
    @game = Game.find(params[:id])
    @pieces = @game.pieces
    @piece = Piece.find(params[:piece_id])
    @piece_id = params[:piece_id]
    @x_pos = params[:x_pos]
    @y_pos = params[:y_pos]
  end

  def move
    @game = Game.find(params[:id])
    @pieces = @game.pieces
    @piece = Piece.find(params[:piece_id])
    @piece_id = params[:piece_id]
    @x_pos = params[:x_pos]
    @y_pos = params[:y_pos]
    @piece.update_attributes({:x_pos => @x_pos, :y_pos => @y_pos})
    redirect_to game_path(@game)
  end

  private

  def game_params
    params.require(:game).permit(:name)
  end

end
