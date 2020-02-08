class Game < ApplicationRecord
  has_many :pieces
  has_many :users

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

  def render_piece(tile_x_position, tile_y_position)
    if(tile_is_occupied?(tile_x_position, tile_y_position))
      result = pieces.find_by(x_pos: tile_x_position, y_pos: tile_y_position)
      if result
        class_name = result.class.name
        #player_color = User.find_by(id: result.player_id) == white_player_id ? "White" : "Black"
        #return player_color + " " + class_name
        return class_name
      else
        return nil
      end
    else
      return nil
    end
  end

  # Note that if we change player id to color (int), it will make this much simpler

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
