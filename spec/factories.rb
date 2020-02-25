
FactoryBot.define do

	factory :game do
		name { "PlayerName" }
		white_player_id { 0 }	# watch these defaults, they may be changed, depending on tests
		black_player_id { 0 }	# typo in definition migration
		#pieces { Array.new }	# To avoid errors, pieces will need to be added to this array inside tests
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

  factory :pawn do
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

