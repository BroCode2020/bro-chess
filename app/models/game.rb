class Game < ApplicationRecord
  has_many :pieces
  has_many :users
  
  belongs_to :black_player, class_name: 'User', optional: true
  belongs_to :white_player, class_name: 'User', optional: true

  after_create :initialize_board!

  def get_svg_data_string(cur_piece, x_position, y_position, scale, svg_url)
    
    color = cur_piece.color
    piece_class_name = cur_piece.class.name.downcase

    case piece_class_name
    when 'king'
      column_number = 0
    when 'queen'
      column_number = 1
    when 'bishop'
      column_number = 2
    when 'knight'
      column_number = 3
    when 'rook'
      column_number = 4
    when 'pawn'
      column_number = 5
    else
      'INVALID PIECE'
    end

    x_coord = scale * column_number
    y_coord = color == 1 ? 0 : scale

    data_string = svg_url +'#svgView(viewBox('
    data_string += x_coord.to_s + ', ' + y_coord.to_s + ', '
    data_string += scale.to_s + ', ' + scale.to_s + '))'

    return data_string
  end


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
        color: true
        )
    end

    Rook.create(game_id: id, x_pos: 0, y_pos: 0, color: true)
    Rook.create(game_id: id, x_pos: 7, y_pos: 0, color: true)

    Knight.create(game_id: id, x_pos: 1, y_pos: 0, color: true)
    Knight.create(game_id: id, x_pos: 6, y_pos: 0, color: true)

    Bishop.create(game_id: id, x_pos: 2, y_pos: 0, color: true)
    Bishop.create(game_id: id, x_pos: 5, y_pos: 0, color: true)

    Queen.create(game_id: id, x_pos: 3, y_pos: 0, color: true)
    King.create(game_id: id, x_pos: 4, y_pos: 0, color: true)

    # Black Pieces
    (0..7).each do |i|
      Pawn.create(
        game_id: id,
        x_pos: i,
        y_pos: 6,
        color: false
        )
    end

    Rook.create(game_id: id, x_pos: 0, y_pos: 7, color: false)
    Rook.create(game_id: id, x_pos: 7, y_pos: 7, color: false)

    Knight.create(game_id: id, x_pos: 1, y_pos: 7, color: false)
    Knight.create(game_id: id, x_pos: 6, y_pos: 7, color: false)

    Bishop.create(game_id: id, x_pos: 2, y_pos: 7, color: false)
    Bishop.create(game_id: id, x_pos: 5, y_pos: 7, color: false)

    Queen.create(game_id: id, x_pos: 3, y_pos: 7, color: false)
    King.create(game_id: id, x_pos: 4, y_pos: 7, color: false)
  end


  def in_check_state?
    return (king_in_check?(0) || king_in_check?(1))
  end

  def king_in_check?(king_color)
    if(king_color != 0 && king_color != 1)
      raise(RuntimeError, 'Invalid color provided. Must be 0 for black or 1 for white.')
      # return false
    end

    king_to_test = pieces.find_by(type: :King, color: king_color)
    return king_to_test.in_check?
  end

  def move_puts_self_in_check?(piece_to_move, x_target, y_target)

    # Don't forget about casting & en passasant

    # IMPORTANT NOTE: for the time being, this will have to be assumed to be a valid move

    # This method assumes it is being passed a piece by proper player
    #    This needs to be taken into consideration with respect to where this method is being called

    # Capturing will need to be addressed
    # Need to retain original coordinates, including for caputred pieces

    # Note that piece_to_move will have the color of the player, thus that doesn't need to be a method parameter
  end

end
