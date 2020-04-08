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

	describe 'in_checkmate_state?' do
		it "should return false when neither king is in checkmate" do
			game = FactoryBot.create(:game)
			expect(game.in_checkmate_state?).to eq(false)
		end

		it "should return true when the black king is in checkmate" do
			game = FactoryBot.create(:game)
			game.pieces.clear
			$stderr.puts ''
			FactoryBot.create(:king, color: 0, game: game, x_pos: 3, y_pos: 0, moved: true)
			FactoryBot.create(:rook, color: 1, game: game, x_pos: 7, y_pos: 0)
			FactoryBot.create(:rook, color: 1, game: game, x_pos: 0, y_pos: 1)
			FactoryBot.create(:king, color: 1, game: game, x_pos: 7, y_pos: 4, moved: true)
			
			expect(game.in_checkmate_state?).to eq(true)
		end

		it "should return true when the white king is in checkmate" do
			game = FactoryBot.create(:game)
			game.pieces.clear

			FactoryBot.create(:king, color: 1, game: game, x_pos: 3, y_pos: 0, moved: true)
			FactoryBot.create(:rook, color: 0, game: game, x_pos: 7, y_pos: 0)
			FactoryBot.create(:rook, color: 0, game: game, x_pos: 0, y_pos: 1)
			FactoryBot.create(:king, color: 0, game: game, x_pos: 7, y_pos: 4, moved: true)

			expect(game.in_checkmate_state?).to eq(true)
		end

	end

	describe 'king_in_checkmate?(king_color)' do
		it "should raise an error if king color is not 0 or 1" do
			game = FactoryBot.create(:game)
			expect { game.king_in_checkmate?(-1)}.to raise_error(RuntimeError, 'Invalid color provided. Must be 0 for black or 1 for white.')
		end

		it "should return true when black king is in checkmate" do
			game = FactoryBot.create(:game)
			game.pieces.clear

			FactoryBot.create(:king, color: 0, game: game, x_pos: 3, y_pos: 0, moved: true)
			FactoryBot.create(:rook, color: 1, game: game, x_pos: 7, y_pos: 0)
			FactoryBot.create(:rook, color: 1, game: game, x_pos: 0, y_pos: 1)
			FactoryBot.create(:king, color: 1, game: game, x_pos: 7, y_pos: 4, moved: true)

			expect(game.king_in_checkmate?(0)).to eq(true)
		end

		it "should return true when white king is in checkmate" do
			game = FactoryBot.create(:game)
			game.pieces.clear

			FactoryBot.create(:king, color: 1, game: game, x_pos: 3, y_pos: 0, moved: true)
			FactoryBot.create(:rook, color: 0, game: game, x_pos: 7, y_pos: 0)
			FactoryBot.create(:rook, color: 0, game: game, x_pos: 0, y_pos: 1)
			FactoryBot.create(:king, color: 0, game: game, x_pos: 7, y_pos: 4, moved: true)

			expect(game.king_in_checkmate?(1)).to eq(true)
		end

		it "should return true when black king is in scholar's mate via wikipedia/checkmate, Scholar's mate" do
			game = FactoryBot.create(:game)
			game.pieces.clear
			#black pieces
	    FactoryBot.create(:pawn, color: 0, game: game, x_pos: 0, y_pos: 1)
			FactoryBot.create(:pawn, color: 0, game: game, x_pos: 1, y_pos: 1)
			FactoryBot.create(:pawn, color: 0, game: game, x_pos: 2, y_pos: 1)
			FactoryBot.create(:pawn, color: 0, game: game, x_pos: 3, y_pos: 1)
			FactoryBot.create(:pawn, color: 0, game: game, x_pos: 4, y_pos: 3) #pawn opened lane
			FactoryBot.create(:pawn, color: 0, game: game, x_pos: 6, y_pos: 1)
			FactoryBot.create(:pawn, color: 0, game: game, x_pos: 7, y_pos: 1)
	    FactoryBot.create(:rook, color: 0, game: game, x_pos: 0, y_pos: 0)
	    FactoryBot.create(:rook, color: 0, game: game, x_pos: 7, y_pos: 0)
			FactoryBot.create(:knight, color: 0, game: game, x_pos: 2, y_pos: 2)#knights opened up
	    FactoryBot.create(:knight, color: 0, game: game, x_pos: 5, y_pos: 2)#knights opened up
			FactoryBot.create(:bishop, color: 0, game: game, x_pos: 2, y_pos: 0)
			FactoryBot.create(:bishop, color: 0, game: game, x_pos: 5, y_pos: 0)
			FactoryBot.create(:queen, color: 0, game: game, x_pos: 3, y_pos: 0)
			FactoryBot.create(:king, color: 0, game: game, x_pos: 4, y_pos: 0)
			#White Pieces
	    FactoryBot.create(:pawn, color: 1, game: game, x_pos: 0, y_pos: 6)
			FactoryBot.create(:pawn, color: 1, game: game, x_pos: 1, y_pos: 6)
			FactoryBot.create(:pawn, color: 1, game: game, x_pos: 2, y_pos: 6)
			FactoryBot.create(:pawn, color: 1, game: game, x_pos: 3, y_pos: 6)
			FactoryBot.create(:pawn, color: 1, game: game, x_pos: 4, y_pos: 4) #pawn opened up
			FactoryBot.create(:pawn, color: 1, game: game, x_pos: 5, y_pos: 6)
			FactoryBot.create(:pawn, color: 1, game: game, x_pos: 6, y_pos: 6)
			FactoryBot.create(:pawn, color: 1, game: game, x_pos: 7, y_pos: 6)
			FactoryBot.create(:rook, color: 1, game: game, x_pos: 0, y_pos: 7)
			FactoryBot.create(:rook, color: 1, game: game, x_pos: 7, y_pos: 7)
			FactoryBot.create(:knight, color: 1, game: game, x_pos: 1, y_pos: 7)
			FactoryBot.create(:knight, color: 1, game: game, x_pos: 1, y_pos: 7)
			FactoryBot.create(:bishop, color: 1, game: game, x_pos: 2, y_pos: 7)
			FactoryBot.create(:bishop, color: 1, game: game, x_pos: 2, y_pos: 4) #bishop with a lane to the queen, taking away the option for black king to capture queen
			FactoryBot.create(:queen, color: 1, game: game, x_pos: 5, y_pos: 1) #queen in checkmate position
			FactoryBot.create(:king, color: 1, game: game, x_pos: 4, y_pos: 7)

			expect(game.king_in_checkmate?(0)).to eq(true)
		end

		it "should return true when white king is in a fool's checkmate via wikipedia/checkmate, Fool's Mate" do
			game = FactoryBot.create(:game)
			game.pieces.clear
			#black pieces
	    FactoryBot.create(:pawn, color: 0, game: game, x_pos: 0, y_pos: 1)
			FactoryBot.create(:pawn, color: 0, game: game, x_pos: 1, y_pos: 1)
			FactoryBot.create(:pawn, color: 0, game: game, x_pos: 2, y_pos: 1)
			FactoryBot.create(:pawn, color: 0, game: game, x_pos: 3, y_pos: 1)
			FactoryBot.create(:pawn, color: 0, game: game, x_pos: 4, y_pos: 2)
			FactoryBot.create(:pawn, color: 0, game: game, x_pos: 5, y_pos: 1)
			FactoryBot.create(:pawn, color: 0, game: game, x_pos: 6, y_pos: 1)
			FactoryBot.create(:pawn, color: 0, game: game, x_pos: 7, y_pos: 1)
	    FactoryBot.create(:rook, color: 0, game: game, x_pos: 0, y_pos: 0)
	    FactoryBot.create(:rook, color: 0, game: game, x_pos: 7, y_pos: 0)
			FactoryBot.create(:knight, color: 0, game: game, x_pos: 1, y_pos: 0)
	    FactoryBot.create(:knight, color: 0, game: game, x_pos: 6, y_pos: 0)
			FactoryBot.create(:bishop, color: 0, game: game, x_pos: 2, y_pos: 0)
			FactoryBot.create(:bishop, color: 0, game: game, x_pos: 5, y_pos: 0)
			FactoryBot.create(:queen, color: 0, game: game, x_pos: 7, y_pos: 4)
			FactoryBot.create(:king, color: 0, game: game, x_pos: 4, y_pos: 0)
			#White Pieces
	    FactoryBot.create(:pawn, color: 1, game: game, x_pos: 0, y_pos: 6)
			FactoryBot.create(:pawn, color: 1, game: game, x_pos: 1, y_pos: 6)
			FactoryBot.create(:pawn, color: 1, game: game, x_pos: 2, y_pos: 6)
			FactoryBot.create(:pawn, color: 1, game: game, x_pos: 3, y_pos: 6)
			FactoryBot.create(:pawn, color: 1, game: game, x_pos: 4, y_pos: 6)
			FactoryBot.create(:pawn, color: 1, game: game, x_pos: 5, y_pos: 5)
			FactoryBot.create(:pawn, color: 1, game: game, x_pos: 6, y_pos: 4)
			FactoryBot.create(:pawn, color: 1, game: game, x_pos: 7, y_pos: 6)
			FactoryBot.create(:rook, color: 1, game: game, x_pos: 0, y_pos: 7)
			FactoryBot.create(:rook, color: 1, game: game, x_pos: 7, y_pos: 7)
			FactoryBot.create(:knight, color: 1, game: game, x_pos: 1, y_pos: 7)
			FactoryBot.create(:knight, color: 1, game: game, x_pos: 1, y_pos: 7)
			FactoryBot.create(:bishop, color: 1, game: game, x_pos: 2, y_pos: 7)
			FactoryBot.create(:bishop, color: 1, game: game, x_pos: 5, y_pos: 7)
			FactoryBot.create(:queen, color: 1, game: game, x_pos: 3, y_pos: 7)
			FactoryBot.create(:king, color: 1, game: game, x_pos: 4, y_pos: 7)
			print_board(game)
			expect(game.king_in_checkmate?(1)).to eq(true)
		end

		it "should return true when white king is in checkmate, via wikipedia/checkmate, D. Byrne vs. Fischer" do
			game = FactoryBot.create(:game)
			game.pieces.clear
			#black pieces
	    FactoryBot.create(:pawn, color: 0, game: game, x_pos: 2, y_pos: 2)
			FactoryBot.create(:pawn, color: 0, game: game, x_pos: 1, y_pos: 3)
			FactoryBot.create(:pawn, color: 0, game: game, x_pos: 5, y_pos: 1)
			FactoryBot.create(:pawn, color: 0, game: game, x_pos: 6, y_pos: 2)
			FactoryBot.create(:pawn, color: 0, game: game, x_pos: 7, y_pos: 3)
	    FactoryBot.create(:rook, color: 0, game: game, x_pos: 2, y_pos: 6)
	    FactoryBot.create(:knight, color: 0, game: game, x_pos: 2, y_pos: 5)
			FactoryBot.create(:bishop, color: 0, game: game, x_pos: 1, y_pos: 4)
			FactoryBot.create(:bishop, color: 0, game: game, x_pos: 1, y_pos: 5)
			FactoryBot.create(:king, color: 0, game: game, x_pos: 6, y_pos: 1)
			#White Pieces
	    FactoryBot.create(:pawn, color: 1, game: game, x_pos: 7, y_pos: 4)
			FactoryBot.create(:pawn, color: 1, game: game, x_pos: 6, y_pos: 6)
			FactoryBot.create(:knight, color: 1, game: game, x_pos: 4, y_pos: 3)
			FactoryBot.create(:king, color: 1, game: game, x_pos: 2, y_pos: 7)
			expect(game.king_in_checkmate?(1)).to eq(true)
		end

		it "should return true when black is in checkmate, via wikipedia/checkmate, Checkmate with a rook" do
			game = FactoryBot.create(:game)
			game.pieces.clear
			FactoryBot.create(:king, color: 0, game: game, x_pos: 3, y_pos: 0)
	    FactoryBot.create(:rook, color: 1, game: game, x_pos: 6, y_pos: 0)
			FactoryBot.create(:king, color: 1, game: game, x_pos: 3, y_pos: 2)
			expect(game.king_in_checkmate?(0)).to eq(true)
		end

		it "should return true when black is in checkmate, via wikipedia/checkmate, King, bishop & knight" do
			game = FactoryBot.create(:game)
			game.pieces.clear
			FactoryBot.create(:king, color: 0, game: game, x_pos: 7, y_pos: 0)
	    FactoryBot.create(:bishop, color: 1, game: game, x_pos: 5, y_pos: 2)
			FactoryBot.create(:knight, color: 1, game: game, x_pos: 7, y_pos: 2)
			FactoryBot.create(:king, color: 1, game: game, x_pos: 6, y_pos: 2)
			expect(game.king_in_checkmate?(0)).to eq(true)
		end

		it "should return false in this scenario where the king can move out of check" do
			game = FactoryBot.create(:game)
			game.pieces.clear
			#black pieces
	    FactoryBot.create(:pawn, color: 0, game: game, x_pos: 0, y_pos: 1)
			FactoryBot.create(:pawn, color: 0, game: game, x_pos: 1, y_pos: 1)
			FactoryBot.create(:pawn, color: 0, game: game, x_pos: 2, y_pos: 1)
			FactoryBot.create(:pawn, color: 0, game: game, x_pos: 3, y_pos: 1)
			FactoryBot.create(:pawn, color: 0, game: game, x_pos: 4, y_pos: 2)
			FactoryBot.create(:pawn, color: 0, game: game, x_pos: 5, y_pos: 1)
			FactoryBot.create(:pawn, color: 0, game: game, x_pos: 6, y_pos: 1)
			FactoryBot.create(:pawn, color: 0, game: game, x_pos: 7, y_pos: 1)
	    FactoryBot.create(:rook, color: 0, game: game, x_pos: 0, y_pos: 0)
	    FactoryBot.create(:rook, color: 0, game: game, x_pos: 7, y_pos: 0)
			FactoryBot.create(:knight, color: 0, game: game, x_pos: 1, y_pos: 0)
	    FactoryBot.create(:knight, color: 0, game: game, x_pos: 6, y_pos: 0)
			FactoryBot.create(:queen, color: 0, game: game, x_pos: 2, y_pos: 0)
			FactoryBot.create(:bishop, color: 0, game: game, x_pos: 5, y_pos: 0)
			FactoryBot.create(:bishop, color: 0, game: game, x_pos: 7, y_pos: 4)
			FactoryBot.create(:king, color: 0, game: game, x_pos: 4, y_pos: 0)
			#White Pieces
	    FactoryBot.create(:pawn, color: 1, game: game, x_pos: 0, y_pos: 6)
			FactoryBot.create(:pawn, color: 1, game: game, x_pos: 1, y_pos: 6)
			FactoryBot.create(:pawn, color: 1, game: game, x_pos: 2, y_pos: 6)
			FactoryBot.create(:pawn, color: 1, game: game, x_pos: 3, y_pos: 6)
			FactoryBot.create(:pawn, color: 1, game: game, x_pos: 6, y_pos: 4)
			FactoryBot.create(:pawn, color: 1, game: game, x_pos: 7, y_pos: 6)
			FactoryBot.create(:rook, color: 1, game: game, x_pos: 0, y_pos: 7)
			FactoryBot.create(:rook, color: 1, game: game, x_pos: 7, y_pos: 7)
			FactoryBot.create(:knight, color: 1, game: game, x_pos: 1, y_pos: 7)
			FactoryBot.create(:knight, color: 1, game: game, x_pos: 1, y_pos: 7)
			FactoryBot.create(:bishop, color: 1, game: game, x_pos: 2, y_pos: 7)
			FactoryBot.create(:bishop, color: 1, game: game, x_pos: 5, y_pos: 7)
			FactoryBot.create(:queen, color: 1, game: game, x_pos: 3, y_pos: 7)
			FactoryBot.create(:king, color: 1, game: game, x_pos: 4, y_pos: 7)

			expect(game.king_in_checkmate?(1)).to eq(false)
		end

		it "should return false when black king is not in checkmate" do
			game = FactoryBot.create(:game)
			expect(game.king_in_checkmate?(0)).to eq(false)
		end

		it "should return false when white king is not in checkmate" do
			game = FactoryBot.create(:game)
			expect(game.king_in_checkmate?(1)).to eq(false)
		end

	end

	describe 'move_puts_self_in_check?(piece_to_move, x_target, y_target)' do

		it "should raise an error if piece_to_move parameter is nil" do
			game = FactoryBot.create(:game)
			expect { game.move_puts_self_in_check?(nil, 0, 0) }.to raise_error('The piece provided is invalid')
		end

		it "should return true if the move will result in this player being in check" do
			game = FactoryBot.create(:game)
			game.pieces.clear
			king = FactoryBot.create(:king, color: '0', game: game, x_pos: 0, y_pos: 0)
			queen = FactoryBot.create(:queen, color: '1', game: game, x_pos: 7, y_pos: 1)
			# b-king is moving into w-queen's path

			expect(game.move_puts_self_in_check?(king, 0, 1)).to eq(true)
		end

		it "should return false if the move will not result in this player being in check" do
			game = FactoryBot.create(:game)
			game.pieces.clear
			king = FactoryBot.create(:king, color: '0', game: game, x_pos: 0, y_pos: 0)
			queen = FactoryBot.create(:queen, color: '0', game: game, x_pos: 7, y_pos: 1)
			# b-king is moving into b-queen's path

			expect(game.move_puts_self_in_check?(king, 0, 1)).to eq(false)
		end

		it "should return true if the move will result in this player being in check" do
			game = FactoryBot.create(:game)
			game.pieces.clear
			king = FactoryBot.create(:king, color: '0', game: game, x_pos: 0, y_pos: 0)
			rook = FactoryBot.create(:rook, color: '0', game: game, x_pos: 4, y_pos: 0)
			queen = FactoryBot.create(:queen, color: '1', game: game, x_pos: 7, y_pos: 0)
			# b-rook is moving, putting b-king in w-queen's path

			expect(game.move_puts_self_in_check?(rook, 4, 1)).to eq(true)
		end

		it "should return false if the move will not result in this player being in check" do
			game = FactoryBot.create(:game)
			game.pieces.clear
			king = FactoryBot.create(:king, color: '0', game: game, x_pos: 0, y_pos: 0)
			rook = FactoryBot.create(:rook, color: '0', game: game, x_pos: 4, y_pos: 0)
			queen = FactoryBot.create(:queen, color: '0', game: game, x_pos: 7, y_pos: 0)
			# b-rook is moving, putting b-king in b-queen's path

			expect(game.move_puts_self_in_check?(rook, 4, 1)).to eq(false)
		end

		describe "- When king is in check," do

			it "should return true if the move will result in this player still being in check" do
				game = FactoryBot.create(:game)
				game.pieces.clear
				king = FactoryBot.create(:king, color: '0', game: game, x_pos: 0, y_pos: 0)
				queen = FactoryBot.create(:queen, color: '1', game: game, x_pos: 7, y_pos: 0)
				# b-king stays in w-queen's path

				expect(game.move_puts_self_in_check?(king, 1, 0)).to eq(true)
			end

			it "should return false if the move will not result in this player being in check" do
				game = FactoryBot.create(:game)
				game.pieces.clear
				king = FactoryBot.create(:king, color: '0', game: game, x_pos: 0, y_pos: 0)
				queen = FactoryBot.create(:queen, color: '1', game: game, x_pos: 7, y_pos: 0)
				# b-king get out of w-queen's path

				expect(game.move_puts_self_in_check?(king, 0, 1)).to eq(false)
			end

			it "should return true if the move will result in this player still being in check" do
				game = FactoryBot.create(:game)
				game.pieces.clear
				king = FactoryBot.create(:king, color: '0', game: game, x_pos: 0, y_pos: 0)
				rook = FactoryBot.create(:rook, color: '0', game: game, x_pos: 4, y_pos: 1)
				queen = FactoryBot.create(:queen, color: '1', game: game, x_pos: 7, y_pos: 0)
				# b-rook is moving, while b-king is still in w-queen's path

				expect(game.move_puts_self_in_check?(rook, 4, 2)).to eq(true)
			end

			it "should return false if the move will not result in this player being in check" do
				game = FactoryBot.create(:game)
				game.pieces.clear
				king = FactoryBot.create(:king, color: '0', game: game, x_pos: 0, y_pos: 0)
				rook = FactoryBot.create(:rook, color: '0', game: game, x_pos: 4, y_pos: 1)
				queen = FactoryBot.create(:queen, color: '1', game: game, x_pos: 7, y_pos: 0)
				# b-rook is moving, blocking w-queen's path

				expect(game.move_puts_self_in_check?(rook, 4, 0)).to eq(false)
			end

			it "should return false if the move will not result in this player being in check" do
				game = FactoryBot.create(:game)
				game.pieces.clear
				king = FactoryBot.create(:king, color: '0', game: game, x_pos: 0, y_pos: 0)
				rook = FactoryBot.create(:rook, color: '0', game: game, x_pos: 7, y_pos: 7)
				queen = FactoryBot.create(:queen, color: '1', game: game, x_pos: 7, y_pos: 0)
				# b-rook captures w-queen, saving b-king

				expect(game.move_puts_self_in_check?(rook, 7, 0)).to eq(false)
			end
		end
	end

	describe "checking for stalemate" do
			it "should return false if the king is in check" do
				game = FactoryBot.create(:game)
				game.pieces.clear
				black_king = FactoryBot.create(:king, color: 0, game: game, x_pos: 4, y_pos: 4)
				white_queen = FactoryBot.create(:queen, color: 1, game: game, x_pos: 6, y_pos: 4)
				expect(game.stalemate?(black_king.color)).to eq(false)
				expect(game.king_in_check?(black_king.color)).to eq(true)
			end

			it "should return false if the king is in checkmate" do
				game = FactoryBot.create(:game)
				game.pieces.clear
				black_king = FactoryBot.create(:king, color: 0, game: game, x_pos: 3, y_pos: 0, moved: true)
				white_rook = FactoryBot.create(:rook, color: 1, game: game, x_pos: 7, y_pos: 0)
				white_rook = FactoryBot.create(:rook, color: 1, game: game, x_pos: 0, y_pos: 1)
				white_king = FactoryBot.create(:king, color: 1, game: game, x_pos: 7, y_pos: 4, moved: true)

				expect(game.stalemate?(black_king.color)).to eq(false)
				expect(game.king_in_checkmate?(0)).to eq(true)
			end


			it "should return true if king is not in check and there are no valid moves # wiki/stalemate/diagram 1" do
				game = FactoryBot.create(:game)
				game.pieces.clear
				black_king = FactoryBot.create(:king, color: '0', game: game, x_pos: 5, y_pos: 0)
				white_pawn = FactoryBot.create(:pawn, color: '1', game: game, x_pos: 5, y_pos: 1)
				white_king = FactoryBot.create(:king, color: '1', game: game, x_pos: 5, y_pos: 2)
				expect(game.stalemate?(black_king.color)).to eq(true)
			end

			it "should return true if king is not in check and there are no valid moves # wiki/stalemate/diagram 2" do
				game = FactoryBot.create(:game)
				game.pieces.clear
				black_king = FactoryBot.create(:king, color: '0', game: game, x_pos: 0, y_pos: 0)
				black_bishop = FactoryBot.create(:bishop, color: '0', game: game, x_pos: 0, y_pos: 1)
				white_rook = FactoryBot.create(:rook, color: '1', game: game, x_pos: 0, y_pos: 7)
				white_king = FactoryBot.create(:king, color: '1', game: game, x_pos: 2, y_pos: 1)
				expect(game.stalemate?(black_king.color)).to eq(true)
			end

			it "should return true if king is not in check and there are no valid moves # wiki/stalemate/diagram 3" do
				game = FactoryBot.create(:game)
				game.pieces.clear
				black_king = FactoryBot.create(:king, color: '0', game: game, x_pos: 0, y_pos: 7)
				white_rook = FactoryBot.create(:rook, color: '1', game: game, x_pos: 1, y_pos: 6)
				white_king = FactoryBot.create(:king, color: '1', game: game, x_pos: 2, y_pos: 5)
				expect(game.stalemate?(black_king.color)).to eq(true)
			end

			it "should return true if king is not in check and there are no valid moves # wiki/stalemate/diagram 4" do
				game = FactoryBot.create(:game)
				game.pieces.clear
				black_king = FactoryBot.create(:king, color: '0', game: game, x_pos: 0, y_pos: 7)
				black_pawn = FactoryBot.create(:pawn, color: '0', game: game, x_pos: 0, y_pos: 6)
				white_queen = FactoryBot.create(:rook, color: '1', game: game, x_pos: 1, y_pos: 5)
				white_king = FactoryBot.create(:king, color: '1', game: game, x_pos: 6, y_pos: 3)
				expect(game.stalemate?(black_king.color)).to eq(true)
			end

			it "should return true if king is not in check and there are no valid moves # wiki/stalemate/diagram 5" do
				game = FactoryBot.create(:game)
				game.pieces.clear
				black_king = FactoryBot.create(:king, color: '0', game: game, x_pos: 0, y_pos: 0)
				white_pawn = FactoryBot.create(:pawn, color: '1', game: game, x_pos: 0, y_pos: 1)
				white_king = FactoryBot.create(:king, color: '1', game: game, x_pos: 0, y_pos: 2)
				white_bishop = FactoryBot.create(:bishop, color: '1', game: game, x_pos: 5, y_pos: 4)
				expect(game.stalemate?(black_king.color)).to eq(true)
			end

			it "should return false in this scenario where the king only has 1 move to force stalemate or he loses in the longer game # wiki/stalemate/ anand vs kramnik 2007" do
				#this is not a stalemate, but if black_king captures white_p_atk_king then it is a stalemate
				game = FactoryBot.create(:game)
				game.pieces.clear
				black_king = FactoryBot.create(:king, color: '0', game: game, x_pos: 4, y_pos: 4)
				white_p_atk_king = FactoryBot.create(:pawn, color: '1', game: game, x_pos: 5, y_pos: 3)
				white_p_protect_own_king = FactoryBot.create(:pawn, color: '1', game: game, x_pos: 7, y_pos: 4)
				white_king = FactoryBot.create(:king, color: '1', game: game, x_pos: 7, y_pos: 3)
				black_p_1 = FactoryBot.create(:pawn, color: '0', game: game, x_pos: 6, y_pos: 1)
				black_p_2 = FactoryBot.create(:pawn, color: '0', game: game, x_pos: 5, y_pos: 2)
				expect(game.stalemate?(black_king.color)).to eq(false)
				expect(game.stalemate?(white_king.color)).to eq(false)
			end

			it "should return true, same scenario above, though black_king takes pawn to force stalemate # wiki/stalemate/ anand vs kramnik 2007" do
				#this case where black_king camptures white_p_atk_king as described in above test
				game = FactoryBot.create(:game)
				game.pieces.clear
				black_king = FactoryBot.create(:king, color: '0', game: game, x_pos: 5, y_pos: 3)
				white_p_protect_own_king = FactoryBot.create(:pawn, color: '1', game: game, x_pos: 7, y_pos: 4)
				white_king = FactoryBot.create(:king, color: '1', game: game, x_pos: 7, y_pos: 3)
				black_p_1 = FactoryBot.create(:pawn, color: '0', game: game, x_pos: 6, y_pos: 1)
				black_p_2 = FactoryBot.create(:pawn, color: '0', game: game, x_pos: 5, y_pos: 2)
				expect(game.stalemate?(black_king.color)).to eq(false)
				expect(game.stalemate?(white_king.color)).to eq(true)

			end

		end

end

def print_board(game_instance)
	spacing = '  '
	no_piece = '...'
	$stderr.puts spacing
	0.upto(7) do |y|
		row = ''
		0.upto(7) do |x|
			p_text = ''
			p = game_instance.pieces.find_by(x_pos: x, y_pos: y)
			if p
				if(p.color == 0 || p.color == 1)
					p_text = p.color == 0 ? 'b-' : 'w-'
					if(p.is_a? Pawn)
						p_text += 'P'
					elsif(p.is_a? Rook)
						p_text += 'R'
					elsif(p.is_a? Knight)
						p_text += 'K'
					elsif(p.is_a? Bishop)
						p_text += 'B'
					elsif(p.is_a? Queen)
						p_text += 'Q'
					elsif(p.is_a? King)
						p_text += '#'
					end
				else
					p_text = "c=#{p.color}"
				end
			else
				p_text = no_piece
			end
			p_text += spacing if x != 7
			row += p_text
			$stderr.puts row if x == 7
			$stderr.puts spacing if x == 7
		end
	end
end
