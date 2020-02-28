require 'rails_helper'

RSpec.describe Bishop, type: :model do
	let(:bishop) {
		game = FactoryBot.create(:game)
		game.pieces.clear
		FactoryBot.create(:bishop, color: 0, game: game, x_pos: 2, y_pos: 2) 
	}

	describe 'method valid_move?(new_x, new_y)' do

		it 'should return false if piece of the same color is in target position' do
			game_b = FactoryBot.create(:game)
			game_b.pieces.clear
			bishop_b = FactoryBot.create(:bishop, color: 0, game: game_b, x_pos: 2, y_pos: 2) 
			target_piece = FactoryBot.create(:piece, type: Pawn, color: 0, game: game_b, x_pos: 4, y_pos: 4)

			expect(bishop_b.valid_move?(4,4)).to eq(false)
		end

		it 'should return true with piece of opposite color in target position and valid movement pattern (diagonal)' do

			game_b = FactoryBot.create(:game)
			game_b.pieces.clear
			bishop_b = FactoryBot.create(:bishop, color: 0, game: game_b, x_pos: 2, y_pos: 2) 
			target_piece = FactoryBot.create(:piece, type: Pawn, color: 1, game: game_b, x_pos: 4, y_pos: 4)

			expect(bishop_b.valid_move?(4,4)).to eq(true)
		end

		it 'should return false if movement pattern is not diagonal' do
			expect(bishop.valid_move?(3,4)).to eq(false)
		end
		
		it 'should return false if movement pattern is diagonal (+,+)' do
			expect(bishop.valid_move?(4,4)).to eq(true)
		end

		it 'should return false if movement pattern is diagonal (+,-)' do
			expect(bishop.valid_move?(4,0)).to eq(true)
		end

		it 'should return false if movement pattern is diagonal (-,+)' do
			expect(bishop.valid_move?(0,4)).to eq(true)
		end

		it 'should return false if movement pattern is diagonal (-,-)' do
			expect(bishop.valid_move?(0,0)).to eq(true)
		end

		it 'should return false if movement pattern is diagonal and only one tile away(-,-)' do
			expect(bishop.valid_move?(1,1)).to eq(true)
		end

	end


end
