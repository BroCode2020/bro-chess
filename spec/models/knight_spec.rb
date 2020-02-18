require 'rails_helper'

RSpec.describe Knight, type: :model do

	describe 'method valid_move?(new_x, new_y)' do

		it 'should return false if piece of the same color is in target position' do

			# make sure this won't mess up other tests... 
			# knight at 7,7?

			expect(false).to eq(true)
		end

		it 'should return true with piece of opposite color in target position and valid "L-pattern"' do

			expect(false).to eq(true)
		end

		it 'should return false if movement pattern is not 1x2 or 2x1' do
			game = FactoryBot.create(:game) 
			game.pieces.clear
			knight = FactoryBot.create(:knight, color: '0', game: game, x_pos: 2, y_pos: 2)

			expect(knight.valid_move?(4,4)).to eq(false)
		end
		
		describe '- With movement pattern 1x2, it' do
			it 'should return true (+,+)' do
				game = FactoryBot.create(:game) 
				game.pieces.clear
				knight = FactoryBot.create(:knight, color: '0', game: game, x_pos: 2, y_pos: 2) 
	
				expect(knight.valid_move?(3,4)).to eq(true)
			end
				
			it 'should return true (+,-)' do
				game = FactoryBot.create(:game) 
				game.pieces.clear
				knight = FactoryBot.create(:knight, color: '0', game: game, x_pos: 2, y_pos: 2) 
				
				expect(knight.valid_move?(3,0)).to eq(true)
			end

			it 'should return true (-,+)' do
				game = FactoryBot.create(:game) 
				game.pieces.clear
				knight = FactoryBot.create(:knight, color: '0', game: game, x_pos: 2, y_pos: 2) 

				expect(knight.valid_move?(1,4)).to eq(true)
			end

			it 'should return true (-,-)' do
				game = FactoryBot.create(:game) 
				game.pieces.clear
				knight = FactoryBot.create(:knight, color: '0', game: game, x_pos: 2, y_pos: 2) 

				expect(knight.valid_move?(1,0)).to eq(true)
			end
		end

		describe '- With movement pattern 2x1, it' do

			it 'should return true (+,+)' do
				game = FactoryBot.create(:game) 
				game.pieces.clear
				knight = FactoryBot.create(:knight, color: '0', game: game, x_pos: 2, y_pos: 2) 
	
				expect(knight.valid_move?(4,3)).to eq(true)
			end
	
			it 'should return true (+,-)' do
				game = FactoryBot.create(:game) 
				game.pieces.clear
				knight = FactoryBot.create(:knight, color: '0', game: game, x_pos: 2, y_pos: 2) 
				
				expect(knight.valid_move?(4,1)).to eq(true)
			end
	
			it 'should return true (-,+)' do
				game = FactoryBot.create(:game) 
				game.pieces.clear
				knight = FactoryBot.create(:knight, color: '0', game: game, x_pos: 2, y_pos: 2) 
	
				expect(knight.valid_move?(0,3)).to eq(true)
			end
	
			it 'should return true (-,-)' do
				game = FactoryBot.create(:game) 
				game.pieces.clear
				knight = FactoryBot.create(:knight, color: '0', game: game, x_pos: 2, y_pos: 2) 
	
				expect(knight.valid_move?(0,1)).to eq(true)
			end

		end
	end
end