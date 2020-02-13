class Game < ApplicationRecord
  has_many :pieces
  has_many :users
  belongs_to :black_player, class_name: 'User', optional: true
  belongs_to :white_player, class_name: 'User', optional: true



  def get_svg_data_string(x_position, y_position, scale, svg_url)
   
    cur_piece = pieces.find_by(x_pos: x_position, y_pos: y_position)
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
    end
  end

  def tile_is_occupied? (tile_x_position, tile_y_position)

    pieces.each do |p|
      return true if(p.x_pos == tile_x_position && p.y_pos == tile_y_position)
    end

    return false
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
