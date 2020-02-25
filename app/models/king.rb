class King < Piece

  def valid_move?(new_x, new_y)
    cur_game = Game.find_by(id: game_id)

    if cur_game.tile_is_occupied?(new_x, new_y)
      p = cur_game.pieces.find_by(x_pos: new_x, y_pos: new_y)

      # if the piece at target location and this piece are the same color, move is invalid
      return false if (p && p.color == color)
    end


	   x_diff = (x_pos - new_x).abs
	   y_diff = (y_pos - new_y).abs
     return true if (x_diff <= 1) && (y_diff <= 1)
  end

  def in_check?
    
    opposing_color = (color == 0 ? 1 : 0)

    cur_game = Game.find_by(id: game_id)
    opposing_pieces = cur_game.pieces.where(color: opposing_color)

    
    opposing_pieces.each do |p|
      return true if p.valid_move?(x_pos, y_pos)
    end

    return false
  end

end
