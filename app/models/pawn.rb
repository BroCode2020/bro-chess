class Pawn < Piece

  def valid_move?(new_x, new_y)
    #at 5,5 want to move to 5,6 -> return true
    return true if valid_diagonal_move?(new_x, new_y)

    return false if new_x != x_pos

    if white?
      return false if new_y <= y_pos
    else
      return false if new_y >= y_pos
    end

    if (new_y - y_pos).abs == 1
      return false if game.tile_is_occupied?(new_x, new_y)
    end

    if (new_y - y_pos).abs == 2 && !has_moved?
      return false if game.tile_is_occupied?(new_x, new_y)
    end

    if (new_y - y_pos).abs == 2 && has_moved?
      return false
    end

    if (new_y - y_pos).abs > 2
      return false
    end

    return true

  end

  def has_moved?
    if color == 1 && y_pos != 1 #white pawns
      return true
    end

    if color == 0 && y_pos != 6 #black pawns
      return true
    end
    
    return false
    
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
