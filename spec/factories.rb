FactoryBot.define do

	factory :game do
		name { "PlayerName" }

		white_player_id { 0 }
		black_player_id { 0 }


	end

	factory :piece do
		x_pos { 0 }
		y_pos { 0 }
		type { "Pawn" }
		game_id { 1 }
		color { 0 }
	end

	factory :king do
  	association :game
	end

	factory :knight do
	end


	factory :user do
		sequence :email do |n|
			"user#{n}@example.com"
		end
		password { "password" }
	end

end
