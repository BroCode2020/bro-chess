class ViewBro

	def self.msg_for_already_forfeited
		return 'This game has already been forfeited.'
	end

	def self.msg_for_forfeited_game
		return 'You have forfeited the game. Please play again soon.'
	end

	def self.msg_for_game_non_member
		return 'You are not a member of this game.'
	end

	def self.msg_for_moving_into_check
		return 'You cannot move into check.'
	end

	def self.msg_for_moving_outside_of_turn
		return 'You can only move on your turn.'
	end

	def self.msg_for_not_signed_in
		return 'You need to sign in or sign up before continuing.'
	end

	def self.msg_for_stalemate
		return 'The game has ended in a stalemate.'
	end

	def self.svg_scale 
		return 45
	end

	def self.from_0_to_7 (reverse_order)
		return (0..7).to_a.reverse if reverse_order
		return (0..7)
	end

	def player_okay_to_join (user_player, game_to_join, join_color)
		return false if (join_color < 0 || join_color > 1)
		
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
	
		x_coord = svg_scale * column_number
		y_coord = color == 1 ? 0 : svg_scale
	
		data_string = svg_url +'#svgView(viewBox('
		data_string += x_coord.to_s + ', ' + y_coord.to_s + ', '
		data_string += svg_scale.to_s + ', ' + svg_scale.to_s + '))'
	
		return data_string
	  end
end
