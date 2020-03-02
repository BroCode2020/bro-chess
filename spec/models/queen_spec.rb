require 'rails_helper'
RSpec.describe Queen, type: :model do
  let(:queen) {
		game = FactoryBot.create(:game)
		game.pieces.clear
		FactoryBot.create(:queen, color: 0, game: game, x_pos: 5, y_pos: 5)
	}


  describe 'movement of the queen' do
    it 'should be able to move two tiles down' do
      expect(queen.valid_move?(5, 3)).to eq true
    end
    it 'should be able to move two tiles up' do
      expect(queen.valid_move?(5, 7)).to eq true
    end
    it 'should be able to move four tiles left' do
      expect(queen.valid_move?(1, 5)).to eq true
    end
    it 'should be able to move two tiles right' do
      expect(queen.valid_move?(7, 5)).to eq true
    end
    it 'should return true if it is a diagonal move' do

      expect(queen.valid_move?(3, 7)).to eq true
      expect(queen.valid_move?(7, 7)).to eq true
      expect(queen.valid_move?(1, 1)).to eq true
      expect(queen.valid_move?(7, 3)).to eq true
    end

    it 'should return false if piece of the same color is obstructed' do
      game_b = FactoryBot.create(:game)
      game_b.pieces.clear
      queen_b = FactoryBot.create(:queen, color: 1, game: game_b, x_pos: 5, y_pos: 5)
      target_piece = FactoryBot.create(:piece, type: Pawn, color: 0, game: game_b, x_pos: 6, y_pos: 5)
      expect(queen_b.valid_move?(7, 5)).to eq false
     end
 end
end
