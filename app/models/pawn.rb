class Pawn < Piece

  def valid_move?(new_x, new_y)
    return false if new_x == x_pos && new_y == y_pos
    
    return true if valid_diagonal_move?(new_x, new_y)
    return true if en_passant?(new_x, new_y)
    return false if new_x != x_pos

    return false if white? && new_y >= y_pos
    return false if black? && new_y <= y_pos

    return false if game.piece_at(new_x, new_y)

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

  def moving_into_promotion?(new_x, new_y)
    return false if !valid_move?(new_x, new_y)
    return color == 0 ? (new_y == 7) : (new_y == 0)
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

  def diagonal_ep(new_x, new_y)
    x_diff = (new_x - x_pos).abs
    y_diff = (new_y - y_pos)

    if white?
      return true if x_diff == 1 && y_diff == -1
    else
      return true if x_diff == 1 && y_diff == 1
    end
  end

  def en_passant?(new_x, new_y)
    #has to move one space forward diagonal left or right
    return false unless diagonal_ep(new_x, new_y)
    adjacent_right = game.pieces.where(x_pos: x_pos + 1, y_pos: y_pos, type: "Pawn").first
    adjacent_left = game.pieces.where(x_pos: x_pos - 1, y_pos: y_pos, type: "Pawn").first
    # must have a pawn adjacent
    return false unless adjacent_left || adjacent_right
    if new_x < x_pos && adjacent_left # moving diagonal left with enemy pawn to left
      return false unless game.last_moved_piece_id == adjacent_left.id # enemy pawn has to be last piece moved
      return false unless (game.last_moved_prev_y_pos - adjacent_left.y_pos).abs == 2 # has to be 2 space move
      return adjacent_left.update_attributes(:x_pos => nil, :y_pos => nil) # will evaluate to true, can be used for capture logic later
    elsif new_x > x_pos && adjacent_right # moving diagonal right with enemy pawn to right
      return false unless game.last_moved_piece_id == adjacent_right.id # enemy pawn has to be last piece moved
      return false unless (game.last_moved_prev_y_pos - adjacent_right.y_pos).abs == 2 # has to be 2 space move
      return adjacent_right.update_attributes(:x_pos => nil, :y_pos => nil) # will evaluate to true, and capture opposing pawn
    end
    return false
  end
end
