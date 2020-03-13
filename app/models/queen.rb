class Queen < Piece
  def valid_move?(new_x, new_y)
    return false if new_x == x_pos && new_y == y_pos
    return false if obstructed?(new_x, new_y)

    x_diff = (x_pos - new_x).abs
    y_diff = (y_pos - new_y).abs
    return true if (x_diff <= 8) && (y_diff == 0)
    return true if (x_diff == 0) && (y_diff <= 8)
    return true if x_diff  ==  y_diff
    return false

  end
end


def obstructed?(x_destination, y_destination)
   game = Game.find(self.game_id)
   x_location = self.x_pos
   y_location = self.y_pos
   #check for vertical obstructions
    if x_location == x_destination
     y_location > y_destination ? incrementer = -1 : incrementer = 1
     y_position = y_location + incrementer
     while y_position != y_destination
       if game.pieces.where(x_pos: x_location, y_pos: y_position).any?
         return true
       end
       y_position += incrementer
     end
     return false
   #check for horizontal obstructions
    elsif y_location == y_destination
     x_location > x_destination ? incrementer = -1 : incrementer = 1
     x_position = x_location + incrementer
     while x_position != x_destination
       if game.pieces.where(x_pos: x_position, y_pos: y_location).any?
         return true
       end
       x_position += incrementer
     end
     return false
   #check for diagonal obstructions
    elsif (x_location - x_destination).abs == (y_location - y_destination).abs
     x_location > x_destination ? x_incrementer = -1 : x_incrementer = 1
     y_location > y_destination ? y_incrementer = -1 : y_incrementer = 1
     x_position = x_location + x_incrementer
     y_position = y_location + y_incrementer
     while x_position != x_destination && y_position != y_destination
       if game.pieces.where(x_pos: x_position, y_pos: y_position).any?
         return true
       end
       x_position += x_incrementer
       y_position += y_incrementer
     end
     return false
    else
      return false
    end
 end
