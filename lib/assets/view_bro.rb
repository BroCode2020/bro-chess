class ViewBro
	attr_reader :msg_about_already_forfeited
	attr_reader :msg_for_forfeited_game
	attr_reader :msg_for_game_non_member
	attr_reader :msg_for_moving_outside_of_turn
	attr_reader :msg_for_not_signed_in

	@@msg_for_already_forfeited = "This game has already been forfeited."
	@@msg_for_forfeited_game ="You have forfeited the game. Please play again soon."
	@@msg_for_game_non_member ="You are not a member of this game."
	@@msg_for_moving_outside_of_turn ="You can only move on your turn."
	@@msg_for_not_signed_in = "You need to sign in or sign up before continuing."
end
