require 'rails_helper'

RSpec.describe Rook, type: :model do
	let(:rook) {
		game = FactoryBot.create(:game)
		game.pieces.clear
		FactoryBot.create(:rook, color: 0, game: game, x_pos: 2, y_pos: 2)
	}

	describe 'method valid_move?(new_x, new_y)' do

		it 'should return false if piece tries to move off the game board' do
			expect(rook.valid_move?(8,2)).to eq(false)
      expect(rook.valid_move?(-1,2)).to eq(false)
      expect(rook.valid_move?(5, -1)).to eq(false)
      expect(rook.valid_move?(4, 8)).to eq(false)
		end

    it "should return true if moving along a column" do
      expect(rook.valid_move?(2, 3)).to eq(true)
    end

    it "should return true if moving along a row" do
      expect(rook.valid_move?(3, 2)).to eq(true)
    end

    it "should return false if moving along a row and column" do
      expect(rook.valid_move?(3, 3)).to eq(false)
    end

    it "should return false if moving along a row and is obstructed" do
 		 	FactoryBot.create(:rook, color: 0, game: rook.game, x_pos: 4, y_pos: 2)
      expect(rook.valid_move?(5, 2)).to eq(false)
    end

    it "should return false if moving along a column and is obstructed" do
      FactoryBot.create(:rook, color: 0, game: rook.game, x_pos: 2, y_pos: 3)
      expect(rook.valid_move?(2, 5)).to eq(false)
    end

    it "should return false if moving to its current position" do
      expect(rook.valid_move?(rook.x_pos, rook.y_pos)).to eq(false)
    end
  end
end
