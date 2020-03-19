class Game < ApplicationRecord
  has_many :pieces
  has_many :users

  belongs_to :black_player, class_name: 'User', optional: true
  belongs_to :white_player, class_name: 'User', optional: true

  after_create :initialize_board!

  def tile_is_occupied? (tile_x_position, tile_y_position)

    pieces.each do |p|
      return true if(p.x_pos == tile_x_position && p.y_pos == tile_y_position)
    end

    return false
  end

  def piece_at(x, y)
    pieces.where(x_pos: x, y_pos: y).first
  end


  def initialize_board!
    # White Pieces
    (0..7).each do |i|
      Pawn.create(
        game_id: id,
        x_pos: i,
        y_pos: 1,
        color: 0
        )
    end

    Rook.create(game_id: id, x_pos: 0, y_pos: 0, color: 0)
    Rook.create(game_id: id, x_pos: 7, y_pos: 0, color: 0)

    Knight.create(game_id: id, x_pos: 1, y_pos: 0, color: 0)
    Knight.create(game_id: id, x_pos: 6, y_pos: 0, color: 0)

    Bishop.create(game_id: id, x_pos: 2, y_pos: 0, color: 0)
    Bishop.create(game_id: id, x_pos: 5, y_pos: 0, color: 0)

    Queen.create(game_id: id, x_pos: 3, y_pos: 0, color: 0)
    King.create(game_id: id, x_pos: 4, y_pos: 0, color: 0)

    # Black Pieces
    (0..7).each do |i|
      Pawn.create(
        game_id: id,
        x_pos: i,
        y_pos: 6,
        color: 1
        )
    end

    Rook.create(game_id: id, x_pos: 0, y_pos: 7, color: 1)
    Rook.create(game_id: id, x_pos: 7, y_pos: 7, color: 1)

    Knight.create(game_id: id, x_pos: 1, y_pos: 7, color: 1)
    Knight.create(game_id: id, x_pos: 6, y_pos: 7, color: 1)

    Bishop.create(game_id: id, x_pos: 2, y_pos: 7, color: 1)
    Bishop.create(game_id: id, x_pos: 5, y_pos: 7, color: 1)

    Queen.create(game_id: id, x_pos: 3, y_pos: 7, color: 1)
    King.create(game_id: id, x_pos: 4, y_pos: 7, color: 1)
  end


  def in_check_state?
    return (king_in_check?(0) || king_in_check?(1))
  end


  def king_in_check?(king_color)
    if(king_color != 0 && king_color != 1)
      raise(RuntimeError, 'Invalid color provided. Must be 0 for black or 1 for white.')
    end

    king_to_test = pieces.find_by(type: :King, color: king_color)
    return king_to_test.in_check?
  end


  def in_checkmate_state?
    return (king_in_checkmate?(0) || king_in_checkmate?(1))
  end


  def king_in_checkmate?(king_color)
    if(king_color != 0 && king_color != 1)
      raise(RuntimeError, 'Invalid color provided. Must be 0 for black or 1 for white.')
    end
    king_in_question = pieces.find_by(type: :King, color: king_color)
    return false if !king_in_question.in_check?

    pieces.where(color: king_color).each do |p|
      for y in 0..7 do
        for x in 0..7 do
          if p.valid_move?(x, y) && p.x_pos != x && p.y_pos != y
            if !move_puts_self_in_check?(p, x, y) && !king_in_question.in_check?
              return false
            end
          end
        end
      end

    end
    return true
  end

    return false
  end

  def in_stalemate_state?
    return stalemate?(0) || stalemate?(1)
  end

  def stalemate?(king_color)
    return false if king_in_check?(king_color)
    return false if king_in_checkmate?(king_color)
    pieces.where(color: king_color).each do |p|
      for y in 0..7 do
        for x in 0..7 do
          if p.valid_move?(x, y) && p.x_pos != x && p.y_pos != y
            return false if (!move_puts_self_in_check?(p, x, y))
          end
        end
      end
    end
    return true
  end


  def move_puts_self_in_check?(piece_to_move, x_target, y_target)

    # What happens if pawn reaches other side during this move check?

    raise 'The piece provided is invalid' if piece_to_move.nil?

    original_pos = [piece_to_move.x_pos, piece_to_move.y_pos]

    piece_in_destination = pieces.find_by(x_pos: x_target, y_pos: y_target)

    if piece_in_destination
      return false if piece_in_destination.is_a?(King)

      # Change piece's color to a value that is not 0 or 1
        # This will exclude it from being used to determine if game is in check state

      dest_piece_color = piece_in_destination.color
      piece_in_destination.update_attributes(color: dest_piece_color + 2)
    end

    piece_to_move.update_attributes(x_pos: x_target, y_pos: y_target)

    # store result (boolean: if game would be in check state), then return attributes to their original state

    in_check_result = king_in_check?(piece_to_move.color)

    piece_to_move.update_attributes(x_pos: original_pos[0], y_pos: original_pos[1])

    if piece_in_destination
      piece_in_destination.update_attributes(color: dest_piece_color)
    end

    return in_check_result
  end

  def player_on_move_id
    return player_on_move_color == 0 ? black_player_id : white_player_id
  end

  def player_on_move
    return player_on_move_color == 0 ? black_player : white_player
  end

  def complete_turn
    new_player_on_move_color = player_on_move_color == 0 ? 1 : 0
    self.update_attributes(player_on_move_color: new_player_on_move_color)

    transmit_player_on_move_to_firebase(new_player_on_move_color)
  end

  def transmit_game_ended_status_to_firebase(game_ended_boolean_state)
    base_uri = 'https://bro-chess-b8ed8.firebaseio.com/'
    firebase = Firebase::Client.new(base_uri)

    firebase.update("game #{id}", :game_ended_boolean => game_ended_boolean_state)
  end

  def transmit_player_on_move_to_firebase(new_player_on_move_color)
    base_uri = 'https://bro-chess-b8ed8.firebaseio.com/'
    firebase = Firebase::Client.new(base_uri)

    firebase.update("game #{id}", :player_on_move_color => new_player_on_move_color)
  end

end
