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

	def self.svg_data_string_for_piece(cur_piece, svg_url)
		piece_class_name = cur_piece.class.name.downcase
		self.customized_svg_data_string_for_piece(svg_url, piece_class_name, cur_piece.color, svg_scale)
	end

	def self.customized_svg_data_string_for_piece (svg_url, piece_class_name, color, custom_svg_scale)

		piece_class_name = piece_class_name.downcase
	
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
	
		x_coord = custom_svg_scale * column_number
		y_coord = color == 1 ? 0 : custom_svg_scale
	
		data_string = svg_url +'#svgView(viewBox('
		data_string += x_coord.to_s + ', ' + y_coord.to_s + ', '
		data_string += custom_svg_scale.to_s + ', ' + custom_svg_scale.to_s + '))'
	
		return data_string
	end

	def self.player_okay_to_join_game? (user_player, game_to_join, join_color)
		return false if (join_color < 0 || join_color > 1)
		return false if !game_okay_to_be_joined?(game_to_join)
		
		return join_color == 0 ? game_ready_for_black_to_join?(game_to_join) : game_ready_for_white_to_join?(game_to_join)
	end

	private

	def self.game_okay_to_be_joined? (game_to_join)
		return false if game_to_join.nil?
		return false if game_to_join.ended
		return false if (!game_to_join.black_player_id.nil? && !game_to_join.white_player_id.nil?)
		return true
	end

	def self.game_ready_for_black_to_join? (game_to_join)
		return (game_to_join.black_player_id.nil? && game_to_join.white_player_id)
	end

	def self.game_ready_for_white_to_join? (game_to_join)
		return (game_to_join.black_player_id && game_to_join.white_player_id.nil?)
	end

end
