require 'rails_helper'

RSpec.describe Knight, type: :model do
	let(:knight) {
		game = FactoryBot.create(:game, black_player_id: 2)
		game.pieces.clear
		FactoryBot.create(:knight, color: 0, game: game, x_pos: 2, y_pos: 2)
	}

	describe 'method valid_move?(new_x, new_y)' do

		it 'should return false if piece of the same color is in target position' do
			game_b = FactoryBot.create(:game)
			game_b.pieces.clear
			knight_b = FactoryBot.create(:knight, color: 0, game: game_b, x_pos: 2, y_pos: 2)
			target_piece = FactoryBot.create(:piece, type: Pawn, color: 0, game: game_b, x_pos: 3, y_pos: 4)

			expect(knight_b.valid_move?(3,4)).to eq(false)
		end

		it 'should return true with piece of opposite color in target position and valid movement pattern (1x2)' do
			game_b = FactoryBot.create(:game)
			game_b.pieces.clear
			knight_b = FactoryBot.create(:knight, color: 0, game: game_b, x_pos: 2, y_pos: 2)
			target_piece = FactoryBot.create(:piece, type: Pawn, color: 1, game: game_b, x_pos: 3, y_pos: 4)

			expect(knight_b.valid_move?(3,4)).to eq(true)
		end

		it 'should return true with piece of opposite color in target position and valid movement pattern (2x1)' do
			game_b = FactoryBot.create(:game)
			game_b.pieces.clear
			knight_b = FactoryBot.create(:knight, color: 1, game: game_b, x_pos: 2, y_pos: 2)
			target_piece = FactoryBot.create(:piece, type: Pawn, color: 0, game: game_b, x_pos: 4, y_pos: 3)

			expect(knight_b.valid_move?(3,4)).to eq(true)
		end

		it 'should return false if movement pattern is not 1x2 or 2x1' do
			expect(knight.valid_move?(4,4)).to eq(false)
		end

		describe '- With movement pattern 1x2, it' do
			it 'should return true (+,+)' do
				expect(knight.valid_move?(3,4)).to eq(true)
			end

			it 'should return true (+,-)' do
				expect(knight.valid_move?(3,0)).to eq(true)
			end

			it 'should return true (-,+)' do
				expect(knight.valid_move?(1,4)).to eq(true)
			end

			it 'should return true (-,-)' do
				expect(knight.valid_move?(1,0)).to eq(true)
			end
		end

		describe '- With movement pattern 2x1, it' do

			it 'should return true (+,+)' do
				expect(knight.valid_move?(4,3)).to eq(true)
			end

			it 'should return true (+,-)' do
				expect(knight.valid_move?(4,1)).to eq(true)
			end

			it 'should return true (-,+)' do
				expect(knight.valid_move?(0,3)).to eq(true)
			end

			it 'should return true (-,-)' do
				expect(knight.valid_move?(0,1)).to eq(true)
			end
		end

	end
end
