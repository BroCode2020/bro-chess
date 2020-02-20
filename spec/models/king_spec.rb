require 'rails_helper'
RSpec::Matchers.define_negated_matcher :not_change, :change
RSpec.describe King, type: :model do
  let(:game) { FactoryBot.create(:game) }
  let(:king) { FactoryBot.create(:king, color: '1', game: game, x_pos: 5, y_pos: 5) }

  describe 'movement of the king' do
    it 'should be able to move one field down' do
      expect(king.valid_move?(5, 4)).to eq true
    end
    it 'should be able to move one field up' do
      expect(king.valid_move?(6, 5)).to eq true
    end
    it 'should be able to move one field left' do
      expect(king.valid_move?(5, 6)).to eq true
    end
    it 'should be able to move one field right' do
      expect(king.valid_move?(5, 4)).to eq true
    end
    it 'should return true if it is a diagonal move' do

      expect(king.valid_move?(4, 6)).to eq true
      expect(king.valid_move?(6, 6)).to eq true
      expect(king.valid_move?(4, 4)).to eq true
      expect(king.valid_move?(4, 6)).to eq true
    end
    it 'should return false if it moves more than field' do
      expect(king.valid_move?(7, 7)).to eq false
    end
    it 'should return false if piece of the same color is in target position' do
			king = FactoryBot.create(:king, color: 0, game: game, x_pos: 5, y_pos: 5)
			target_piece = FactoryBot.create(:piece, type: Pawn, color: 0, game: game, x_pos: 6, y_pos: 5)
        expect(king.valid_move?(6, 5)).to eq true
  end
 end
end
