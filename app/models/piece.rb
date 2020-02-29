class Piece < ApplicationRecord
  belongs_to :game

  def position
    "#{self.x_pos}, #{self.y_pos}"
  end


  def move_to!(new_x, new_y)
    self.update_attributes(:moved => true)
    piece_to_capture = self.game.pieces.where(:x_pos => new_x, :y_pos => new_y).first
		if piece_to_capture.present? && self.color.to_i != piece_to_capture.color.to_i
			piece_to_capture.update_attributes(:x_pos => nil, :y_pos => nil) #captured pieces are nil thus not drawn and not clickable
			self.update_attributes(:x_pos => new_x, :y_pos => new_y)
		elsif piece_to_capture.present? && self.color.to_i == piece_to_capture.color
      return false
    else
      self.update_attributes({:x_pos => new_x, :y_pos => new_y,})

    end
    return true
  end


  def never_moved?
  updated_at == created_at
  end




  def is_obstructed?(start_position_x, start_position_y, end_position_x, end_position_y)

    if valid_general_input_target?(start_position_x, start_position_y, end_position_x, end_position_y)

      direction_x = start_position_x < end_position_x ? 1 : -1
      direction_x = 0 if start_position_x == end_position_x

      direction_y = start_position_y < end_position_y ? 1 : -1
      direction_y = 0 if start_position_y == end_position_y

      current_x = start_position_x
      current_y = start_position_y

      loop do

        return true if self.game.tile_is_occupied?(current_x, current_y) && !(current_x == end_position_x && current_y == end_position_y) && !(current_x == start_position_x && current_y == start_position_y)

        current_x += direction_x
        current_y += direction_y
        break if ((current_x == end_position_x) && (current_y == end_position_y))
      end

      return false
    else
      raise 'Invalid input detected. Input is not horizontal, vertical, or diagonal.'
    end
  end

  def white?
    return color == 1
  end

  def black?
    return color == 0
  end

  def pawn_has_moved?
    if color == 1 && y_pos != 1
      return true
    end

    if color == 0 && y_pos != 6
      return true
    else
      return false
    end
  end

  def castle?(rook_x_pos, rook_y_pos)
    rook = game.pieces.find_by(x_pos: rook_x_pos, y_pos: rook_y_pos, type: 'Rook')
    return false if moved?
    return false if rook.nil? || rook.moved?
  #    return false if game.king_in_check?(self.color)
    if rook_x_pos == 7
      while x_pos < rook_x_pos - 1
        update(x_pos: x_pos + 1)
        reload
  # #        if game.king_in_check?(self.color)
  #           update(x_pos: 4)
  #           return false

      end
      update(x_pos: 4)
    end
    if rook_x_pos.zero?
      while x_pos > rook_x_pos + 2
        update(x_pos: x_pos - 1)
        # if game.king_in_check?(self.color)
        #   update(x_pos: 4)
        #   return false

      end
      update(x_pos: 4)
    end
    true
  end

  private

  def valid_general_input_target?(start_position_x, start_position_y, end_position_x, end_position_y)
    # This methods returns true if in general, the inputs are valid.
    #   'In general', meaning horizontal, vertical, OR diagonal movement

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
