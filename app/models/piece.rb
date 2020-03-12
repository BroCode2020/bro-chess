class Piece < ApplicationRecord
  belongs_to :game

  def position
    "#{self.x_pos}, #{self.y_pos}"
  end

  def valid_move?(new_x, new_y)
    # This method is meant to be overridden by derived classes
    piece_at_destination = game.pieces.find_by(x_pos: new_x, y_pos: new_y)
    return false if piece_at_destination && piece_at_destination.color == color
    return true
  end

  def two_players?(new_x, new_y)

    return false if game.black_player_id.nil?
    return true
  end

  def move_to!(new_x, new_y)
    new_x = new_x.to_i
    new_y = new_y.to_i

    orig_x = self.x_pos
    orig_y = self.y_pos


    if valid_move?(new_x, new_y)
      piece_to_capture = self.game.pieces.where(:x_pos => new_x, :y_pos => new_y).first
      if piece_to_capture.present? && self.color.to_i != piece_to_capture.color.to_i
        piece_to_capture.update_attributes(:x_pos => nil, :y_pos => nil) #captured pieces are nil thus not drawn and not clickable
        self.update_attributes(:x_pos => new_x, :y_pos => new_y, :moved => true)
        game.update_attributes(last_moved_piece_id: self.id, last_moved_prev_x_pos: orig_x, last_moved_prev_y_pos: orig_y)
      elsif piece_to_capture.present? && self.color.to_i == piece_to_capture.color
        # cannot capture a piece of the same color
        return false
      else
        # there is no piece to capture
        self.update_attributes({:x_pos => new_x, :y_pos => new_y, :moved => true})

        game.update_attributes(last_moved_piece_id: self.id, last_moved_prev_x_pos: orig_x, last_moved_prev_y_pos: orig_y)

      end
      return true
    else
      return false
    end

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
