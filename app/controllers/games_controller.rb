class GamesController < ApplicationController

  def index
    @games = Game.all
    @available_games = Game.available
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.create(game_params)
    redirect_to game_path(@game)
  end

  def show
    @games = Game.all
    @game = Game.find(params[:id])
    @pieces_by_position = @game.pieces.reduce({}) do |hash, piece|
      hash[piece.position] = piece
      hash
    end
  end

  def select
    @game = Game.find(params[:id])
    @pieces_by_position = @game.pieces.reduce({}) do |hash, piece|
      hash[piece.position] = piece
      hash
    end
    @selected_piece_id = params[:piece_id]
  end

  def move
    @game = Game.find(params[:id])
    @pieces = @game.pieces
    @piece = Piece.find(params[:piece_id])
    @piece_id = params[:piece_id]
    @x_pos = params[:x_pos]
    @y_pos = params[:y_pos]
    #<!-- @piece.move_to! -->
    @piece.update_attributes({:x_pos => @x_pos, :y_pos => @y_pos})
    redirect_to game_path(@game.id)
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

  def forfeit
    @game = Game.find(params[:id])

    if !@game.forfeiting_player_id.nil?
      redirect_to root_path, alert: "This game has already been forfeited." and return
    end
    
    @game.update_attribute(:forfeiting_player_id, current_user.id)
    redirect_to root_path, notice: "You have forfeited the game. Please play again soon." # This fails to render
  end

  private

  def game_params
    params.require(:game).permit(:name, :black_player_id, :white_player_id)
  end

end
