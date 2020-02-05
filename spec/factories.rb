FactoryBot.define do 
	
	factory :game do
		name { "PlayerName" }
		
		white_player_id { 0 }	# watch these defaults, they may be changed, depending on tests
		black_payer_id { 0 }	# typo in definition migration

		pieces { Array.new }	# To avoid errors, pieces will need to be added to this array inside tests

		created_at { DateTime.new(2020,01,01,01,01,01) }
		updated_at { DateTime.new(2020,01,01,01,01,01) }

	end

	factory :piece do
		x_pos { 0 }
		y_pos { 0 }
		piece_type { "Pawn" }	# this will need to be changed to match updated code
		player_id { 1 }
		game_id { 1 }

		created_at { DateTime.new(2020,01,01,01,01,01) }
		updated_at { DateTime.new(2020,01,01,01,01,01) }

	end

	factory :user do
		password { "password" }
		email { "x@x" }

		created_at { DateTime.new(2020,01,01,01,01,01) }
		updated_at { DateTime.new(2020,01,01,01,01,01) }

	end

end
