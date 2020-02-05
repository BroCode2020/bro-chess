FactoryBot.define do 
	
	factory :game do
		name { "PlayerName" }
		white_player_id { 0 }	# watch these defaults, they may be changed, depending on tests
		black_payer_id { 0 }	# typo in definition migration
		pieces { Array.new }	# To avoid errors, pieces will need to be added to this array inside tests
	end

	factory :piece do
		x_pos { 0 }
		y_pos { 0 }
		piece_type { "Pawn" }	# this will need to be changed to match updated code
		player_id { 1 }
		game_id { 1 }
	end

	factory :user do
		sequence :email do |n|
			"user#{n}@example.com"
		end
		password { "password" }
	end

end
