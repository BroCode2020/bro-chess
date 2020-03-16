class GamesController < ApplicationController

  before_action :authenticate_user!, only: [:index, :new, :create, :show, :update, :join_as_black, :join_as_white, :game_available, :forfeit]

  def index
    @games = Game.all
    @available_games = Game.available
  end

  def new
    @game = Game.new
  end

  def create
    @game = Game.create(game_params)
    @game.transmit_player_on_move_to_firebase(-1)
    redirect_to game_path(@game)
  end

  def show
    @games = Game.all
    @game = Game.find(params[:id])

    if(current_user.id != @game.black_player_id && current_user.id != @game.white_player_id)
      redirect_to root_path, alert: "You need to sign in or sign up before continuing." and return
    end

    @pieces_by_position = @game.pieces.reduce({}) do |hash, piece|
      hash[piece.position] = piece
      hash
    end
  end

  def move
    @game = Game.find(params[:id])
    @pieces = @game.pieces
    @piece = Piece.find(params[:piece_id])
    @piece_id = params[:piece_id]
    @x_pos = params[:x_pos].to_i
    @y_pos = params[:y_pos].to_i

    if(current_user.nil?)
      # redirect_to root_path, alert: "You are not a member of this game." and return
    end

    if(current_user.id != @game.black_player_id && current_user.id != @game.white_player_id)
      redirect_to root_path, alert: "You are not a member of this game." and return
    end
    if(current_user != @game.player_on_move)
      redirect_to game_path(@game.id), alert: "You can only move on your turn." and return
    end

    if @game.move_puts_self_in_check?(@piece, @x_pos, @y_pos)
      redirect_to game_path(@game.id), alert: "This game has already been forfeited." and return
    else
      if @piece.move_to!(@x_pos, @y_pos)
        @game.complete_turn
      else
        redirect_to game_path(@game.id)
      end
    end
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

    if(current_user.id != @game.black_player_id && current_user.id != @game.white_player_id)
      redirect_to root_path, alert: "You are not a member of this game." and return
    end
    
    @game = Game.find(params[:id])

    if !@game.forfeiting_player_id.nil?
      redirect_to root_path, alert: "This game has already been forfeited." and return
    end
    
    @game.update_attribute(:forfeiting_player_id, current_user.id)
    current_user.increment_loss_count

    other_player = User.find_by(id: @game.black_player_id == current_user.id ? @game.white_player_id : @game.black_player_id)
    other_player.increment_win_count if other_player

    # Note: other player needs to be redirected (via Firebase)

    redirect_to root_path, notice: "You have forfeited the game. Please play again soon."
  end

  private

  def game_params
    params.require(:game).permit(:name, :black_player_id, :white_player_id)
  end

end
