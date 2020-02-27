require 'rails_helper'

RSpec.describe Game, type: :model do

	describe 'tile_is_occupied?(tile_x_position, tile_y_position)' do

		it "should return true for (0,0) when piece is at (x_pos: 0, y_pos: 0)" do

			game = FactoryBot.create(:game)
			game.pieces.clear
			game.pieces.create(x_pos: 0, y_pos: 0)

			expect(game.tile_is_occupied?(0,0)).to eq(true)
		end

		it "should return false for (1,1) when piece is at (x_pos: 0, y_pos: 0)" do

			game = FactoryBot.create(:game)
			game.pieces.clear
			game.pieces.create(x_pos: 0, y_pos: 0)

			expect(game.tile_is_occupied?(1,1)).to eq(false)
		end
	end

  it "should return a piece count of 32." do

	game = FactoryBot.create(:game)
	expect(game.pieces.count).to eq(32)
  end

  it "should return the king as the last piece that was initialized" do

	game = FactoryBot.create(:game)
	expect(game.pieces.last.type).to eq("King")
  end

  it "Should return the x position of the last piece that was created" do

	game = FactoryBot.create(:game)
	expect(game.pieces.last.x_pos).to eq(4)
  end

  it "Should return the y position of the last piece that was created" do

	game = FactoryBot.create(:game)
	expect(game.pieces.last.y_pos).to eq(7)
  end

	describe 'in_check_state?' do

		it "should return false when neither king is in check" do
			game = FactoryBot.create(:game)
			expect(game.in_check_state?).to eq(false)
		end

		it "should return true when the black king is in check" do
			game = FactoryBot.create(:game)
			game.pieces.clear
			FactoryBot.create(:king, color: 0, game: game, x_pos: 4, y_pos: 4)
			FactoryBot.create(:queen, color: 1, game: game, x_pos: 4, y_pos: 2)
			FactoryBot.create(:king, color: 1, game: game, x_pos: 7, y_pos: 7)

			expect(game.in_check_state?).to eq(true)
		end

		it "should return true when the white king is in check" do
			game = FactoryBot.create(:game)
			game.pieces.clear
			FactoryBot.create(:king, color: 1, game: game, x_pos: 4, y_pos: 4)
			FactoryBot.create(:queen, color: 0, game: game, x_pos: 6, y_pos: 4)
			FactoryBot.create(:king, color: 0, game: game, x_pos: 7, y_pos: 7)
			expect(game.in_check_state?).to eq(true)
		end

		it "should return true when both kings are in check" do
			game = FactoryBot.create(:game)
			game.pieces.clear
			FactoryBot.create(:king, color: 0, game: game, x_pos: 0, y_pos: 0)
			FactoryBot.create(:queen, color: 1, game: game, x_pos: 4, y_pos: 0)
			FactoryBot.create(:king, color: 1, game: game, x_pos: 7, y_pos: 7)
			FactoryBot.create(:queen, color: 0, game: game, x_pos: 3, y_pos: 7)
			expect(game.in_check_state?).to eq(true)
		end
	end
	
	describe 'king_in_check?(king_color)' do

		it "should raise an error if king color is not 0 or 1" do
			game = FactoryBot.create(:game)

			expect {
			  game.king_in_check?(-1).to raise_error(RuntimeError, 'Invalid color provided. Must be 0 for black or 1 for white.')
			}
		end

		it "should return true when black king is in check" do
			game = FactoryBot.create(:game)
			game.pieces.clear
			FactoryBot.create(:king, color: 0, game: game, x_pos: 4, y_pos: 4)
			FactoryBot.create(:queen, color: 1, game: game, x_pos: 4, y_pos: 2)
			expect(game.king_in_check?(0)).to eq(true)
		end

		it "should return true when white king is in check" do
			game = FactoryBot.create(:game)
			game.pieces.clear
			FactoryBot.create(:king, color: 1, game: game, x_pos: 4, y_pos: 4)
			FactoryBot.create(:queen, color: 0, game: game, x_pos: 6, y_pos: 4)
			expect(game.king_in_check?(1)).to eq(true)
		end

		it "should return false when black king is not in check" do
			game = FactoryBot.create(:game)
			expect(game.king_in_check?(0)).to eq(false)
		end

		it "should return false when white king is not in check" do
			game = FactoryBot.create(:game)
			expect(game.king_in_check?(1)).to eq(false)
		end
	end

end
