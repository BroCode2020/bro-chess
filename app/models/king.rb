class King < Piece

  def valid_move?(new_x, new_y)
     x_diff = (x_pos - new_x).abs
	   y_diff = (y_pos - new_y).abs

     return true if (x_diff <= 1) && (y_diff <= 1)
     return false if is_obstructed?(x_pos, y_pos, new_x, new_y)
    end
  end
