class Bishop < Piece

	def valid_move? (new_x, new_y)
		return false if new_x == x_pos && new_y == y_pos
		cur_game = Game.find_by(id: game_id)

		# get the absolute value of the distances moved in x and y directions

		x_dist_abs = (new_x - x_pos).abs
		y_dist_abs = (new_y - y_pos).abs

		return false if x_dist_abs != y_dist_abs

		# if there is a piece at target position...

		if cur_game.tile_is_occupied?(new_x, new_y)
			p = cur_game.pieces.find_by(x_pos: new_x, y_pos: new_y)

			# if the piece at target location and this piece are the same color, move is invalid
			return false if (p && p.color == color)		
		end

		# ensure input is valid in the general sense and isn't obstructed

		return false if is_obstructed?(x_pos, y_pos, new_x, new_y) != false

		return true
		
	end
end
