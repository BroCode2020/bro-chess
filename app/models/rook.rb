class Rook < Piece
  def valid_move?(new_x, new_y)
    return false if out_of_bounds?(new_x)
    return false if out_of_bounds?(new_y)

    return false unless move_along_row?(new_x, new_y) || move_along_column?(new_x, new_y)

    pieces = Piece.where(game_id: game.id)
    if move_along_row?(new_x, new_y)
      pieces.each do |piece|
        if piece.y_pos == y_pos
          return false if between?(piece.x_pos, x_pos, new_x)
        end
      end
    elsif move_along_column?(new_x, new_y)
      pieces.each do |piece|
        if piece.x_pos == x_pos
          return false if between?(piece.y_pos, y_pos, new_y)
        end
      end
    end
    return true
	end

private

  def out_of_bounds?(value)
    return value > 7 || value < 0
  end

  def between?(target, old_pos, new_pos)
    start_of_range = [old_pos, new_pos].min
    end_of_range = [old_pos, new_pos].max

    return target > start_of_range && target < end_of_range
  end

  def move_along_column?(new_x, new_y)
    delta_x = new_x - x_pos
    delta_y = new_y - y_pos

    return delta_x == 0 && delta_y != 0
  end

  def move_along_row?(new_x, new_y)
    delta_x = new_x - x_pos
    delta_y = new_y - y_pos

    return delta_x != 0 && delta_y == 0
  end
end
