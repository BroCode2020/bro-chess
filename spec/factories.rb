FactoryBot.define do 
	
	factory :game do
		name { "PlayerName" }
		white_player_id { 1 }	# watch these defaults, they may be changed, depending on tests
		black_player_id { 1 }	# typo in definition migration
		
	end

	factory :piece do
		x_pos { 0 }
		y_pos { 0 }
		type { "Pawn" }
		player_id { 1 }
		game_id { 1 }
	end

	factory :user do
		sequence :email do |n|
			"user#{n}@example.com"
		end
		password { "password" }
	end

	#factories for Populate game feature
	
end
