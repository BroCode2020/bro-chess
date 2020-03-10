class Pawn < Piece

  def valid_move?(new_x, new_y)

    return true if valid_diagonal_move?(new_x, new_y)

    return false if new_x != x_pos

    return false if white? && new_y >= y_pos
    return false if black? && new_y <= y_pos

    y_move_dist = (new_y - y_pos).abs

    if (y_move_dist == 1)
      return false if game.tile_is_occupied?(new_x, new_y)
    elsif (y_move_dist == 2)
      return false if moved
      return false if game.tile_is_occupied?(new_x, new_y)
    else
      return false
    end

    return true
  end

  private

  def valid_diagonal_move?(new_x, new_y)
    x_diff = (new_x - x_pos).abs
    y_diff = (new_y - y_pos)

    return false if x_diff != 1
    return false if white? && y_diff != -1
    return false if black? && y_diff != 1

    return false if !game.tile_is_occupied?(new_x, new_y)
    piece_at_target = game.piece_at(new_x, new_y)
    return true if piece_at_target && piece_at_target.color != color
  end
  
end
