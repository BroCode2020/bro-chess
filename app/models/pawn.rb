class Pawn < Piece
def valid_move?(new_x, new_y)

    #at 5,5 want to move to 5,6 -> return true
    return true if valid_diagonal_move?(new_x, new_y)
    return true if en_passant?(new_x, new_y)
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

  def move_to!(new_x, new_y)
    orig_x = self.x_pos
    orig_y = self.y_pos
      if valid_move?(new_x, new_y)
        piece_to_capture = self.game.pieces.where(:x_pos => new_x, :y_pos => new_y).first

        if piece_to_capture.present? && self.color.to_i != piece_to_capture.color.to_i
          piece_to_capture.update_attributes(:x_pos => nil, :y_pos => nil) #captured pieces are nil thus not drawn and not clickable
          self.update_attributes(:x_pos => new_x, :y_pos => new_y)
        elsif piece_to_capture.present? && self.color.to_i == piece_to_capture.color

          return false
        else
          self.update_attributes({:x_pos => new_x, :y_pos => new_y})
          game.update_attributes(last_moved_piece_id: self.id, last_moved_prev_x_pos: orig_x, last_moved_prev_y_pos: orig_y)
        end
        return true
      else
        return false
      end
    end


  private

  def valid_diagonal_move?(new_x, new_y)
    x_diff = (new_x - x_pos).abs
    y_diff = (new_y - y_pos)

    return false unless game.tile_is_occupied?(new_x, new_y) && game.piece_at(new_x, new_y).color != color

    if white?
      return true if x_diff == 1 && y_diff == 1
    else
      return true if x_diff == 1 && y_diff == -1
    end

  end

  def diagonal_ep(new_x, new_y)
   x_diff = (new_x - x_pos).abs
   y_diff = (new_y - y_pos)


   if white?
     return true if x_diff == 1 && y_diff == 1
   else
     return true if x_diff == 1 && y_diff == -1
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
    return adjacent_left.update_attributes# will evaluate to true, can be used for capture logic later
  elsif new_x > x_pos && adjacent_right # moving diagonal right with enemy pawn to right
    return false unless game.last_moved_piece_id == adjacent_right.id # enemy pawn has to be last piece moved
    return false unless (game.last_moved_prev_y_pos - adjacent_right.y_pos).abs == 2 # has to be 2 space move
    return adjacent_right.update_attributes(:x_pos => nil, :y_pos => nil) # will evaluate to true, and capture opposing pawn
  end
  return false
end
end
