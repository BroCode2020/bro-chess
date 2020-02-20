require 'rails_helper'

RSpec.describe Bishop, type: :model do
	let(:bishop) {
		game = FactoryBot.create(:game)
		game.pieces.clear
		FactoryBot.create(:bishop, color: 0, game: game, x_pos: 2, y_pos: 2) 
	}


end
