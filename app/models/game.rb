class Game < ApplicationRecord
  has_many :pieces
  has_many :users
  after_create :initialize_board!

  scope :available, -> { where(available: true) }

  def is_obstructed?(start_position_x, start_position_y, end_position_x, end_position_y)

    if valid_input_target?(start_position_x, start_position_y, end_position_x, end_position_y)

      direction_x = start_position_x < end_position_x ? 1 : -1
      direction_x = 0 if start_position_x == end_position_x

      direction_y = start_position_y < end_position_y ? 1 : -1
      direction_y = 0 if start_position_y == end_position_y

      current_x = start_position_x + direction_x
      current_y = start_position_y + direction_y
      
      loop do

        return true if tile_is_occupied?(current_x, current_y)
        current_x += direction_x
        current_y += direction_y

        break if ((current_x == end_position_x) && (current_y == end_position_y)) 
      end

      return false
    else
      raise 'Invalid input detected. Input is not horizontal, vertical, or diagonal.'
      # is anything supposed to be returned here?
    end
  end

  def tile_is_occupied? (tile_x_position, tile_y_position)

    pieces.each do |p|
      return true if(p.x_pos == tile_x_position && p.y_pos == tile_y_position)
    end

    return false
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

  private

  def valid_input_target?(start_position_x, start_position_y, end_position_x, end_position_y)

    if(start_position_x != end_position_x && start_position_y != end_position_y)
      # if both x and y values change
      if (end_position_x - start_position_x).abs == (end_position_y - start_position_y).abs
        # if the x and y value change at the same rate (diagonal movement)
        return true
      else
        return false
      end
    elsif(start_position_x != end_position_x)
      # if only x value changes
      return true
    elsif(start_position_y != end_position_y)
      # if only y value changes
      return true
    else
      #if neither x nor y values change
      return false
    end
  end

end
