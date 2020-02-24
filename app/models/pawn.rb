class Pawn < Piece

  def valid_move?(new_x, new_y)

    return true if valid_diagonal_move?(new_x, new_y)

    return false if new_x != x_pos

    if white?
      return false if new_y >= y_pos
    else
      return false if new_y <= y_pos
    end

    if (new_y - y_pos).abs == 1
      return false if game.tile_is_occupied?(new_x, new_y)
    end

    if (new_y - y_pos).abs == 2 && !pawn_has_moved?
      return false if game.tile_is_occupied?(new_x, new_y)
    end

    if (new_y - y_pos).abs < 1 && pawn_has_moved?
      return false
    end

    return true

  end

  private

  def valid_diagonal_move?(new_x, new_y)
    x_diff = (new_x - x_pos).abs
    y_diff = (new_y - y_pos)

    return false unless game.tile_is_occupied?(new_x, new_y) && game.piece_at(new_x, new_y).color != color

    if white?
      return true if x_diff == 1 && y_diff == -1
    else
      return true if x_diff == 1 && y_diff == 1
    end

  end
end
