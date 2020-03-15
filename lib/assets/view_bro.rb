class ViewBro
	attr_reader :msg_about_already_forfeited
	attr_reader :msg_for_forfeited_game
	attr_reader :msg_for_game_non_member
	attr_reader :msg_for_moving_outside_of_turn
	attr_reader :msg_for_not_signed_in

	attr_reader :svg_scale

	@@msg_for_already_forfeited = "This game has already been forfeited."
	@@msg_for_forfeited_game = "You have forfeited the game. Please play again soon."
	@@msg_for_game_non_member = "You are not a member of this game."
	@@msg_for_moving_outside_of_turn = "You can only move on your turn."
	@@msg_for_not_signed_in = "You need to sign in or sign up before continuing."

	@@svg_scale = 45

	def self.from_0_to_7 (reverse_order)
		return (0..7).to_a.reverse if reverse_order
		return (0..7)
	end

	def self.svg_data_string_for_piece(cur_piece, svg_url)

		color = cur_piece.color
		piece_class_name = cur_piece.class.name.downcase
	
		case piece_class_name
		when 'king'
		  column_number = 0
		when 'queen'
		  column_number = 1
		when 'bishop'
		  column_number = 2
		when 'knight'
		  column_number = 3
		when 'rook'
		  column_number = 4
		when 'pawn'
		  column_number = 5
		else
		  'INVALID PIECE'
		end
	
		x_coord = @@svg_scale * column_number
		y_coord = color == 1 ? 0 : @@svg_scale
	
		data_string = svg_url +'#svgView(viewBox('
		data_string += x_coord.to_s + ', ' + y_coord.to_s + ', '
		data_string += @@svg_scale.to_s + ', ' + @@svg_scale.to_s + '))'
	
		return data_string
	  end
end
