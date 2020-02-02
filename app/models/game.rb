class Game < ApplicationRecord
  has_many :pieces
  belongs_to :user

  def is_obstructed?(start_position_x, start_position_y, end_position_x, end_position_y)

    if valid_input_target?(start_position_x, start_position_y, end_position_x, end_position_y)

      direction_x = start_position_x < end_position_x ? 1 : -1
      direction_x = 0 if start_position_x == end_position_x

      direction_y = start_position_y < end_position_y ? 1 : -1
      direction_y = 0 if start_position_y == end_position_y
      
      current_x = start_position_x + direction_x;
      current_y = start_position_y + direction_y;

      while (current_x != end_position_x) && (current_y != end_position_y) do
        return true if tile_is_occupied?(current_x, current_y)
        current_x += x_direction;
        current_y += y_direction;
      end

      return false  
    else
      raise 'Invalid input detected. Input is not horizontal, vertical, or diagonal.'
      # is anything supposed to be returned here? 
    end
  end

  def tile_is_occupied? (tile_x_position, tile_y_position)
    return @pieces.where({x_position: tile_x_position, y_position: tile_y_position}) != nil # alternatively... tile_y_position}).first != nil
  end

  private

  def valid_input_target?(start_position_x, start_position_y, end_position_x, end_position_y)
    if(start_position_x != end_position_x && start_position_y != end_position_y)
      # if both x and y values change

      if abs(end_position_x - start_position_x) == abs(end_position_y - start_position_y)
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
