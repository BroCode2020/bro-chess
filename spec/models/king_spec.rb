require 'rails_helper'
RSpec.describe King, type: :model do
  let(:game) { FactoryBot.create(:game) }
  let(:king) { FactoryBot.create(:king, color: '0', game: game, x_pos: 4, y_pos: 4) }

  describe 'movement of the king' do
    it 'should be able to move one field down' do
      expect(king.valid_move?(4, 3)).to eq true
    end
    it 'should be able to move one field up' do
      expect(king.valid_move?(4, 5)).to eq true
    end
    it 'should be able to move one field left' do
      expect(king.valid_move?(3, 4)).to eq true
    end
    it 'should be able to move one field right' do
      expect(king.valid_move?(5, 4)).to eq true
    end
    it 'should return true if it is a diagonal move' do

      expect(king.valid_move?(3, 5)).to eq true
      expect(king.valid_move?(5, 5)).to eq true
      expect(king.valid_move?(3, 3)).to eq true
      expect(king.valid_move?(5, 3)).to eq true
    end
    it 'should return false if it moves more than field' do
      expect(king.valid_move?(7, 7)).to eq false
    end
    it 'should return false if piece of the same color is in target position' do
			target_piece = FactoryBot.create(:piece, type: Pawn, color: 0, game: game, x_pos: 5, y_pos: 6)
        expect(king.valid_move?(5, 6)).to eq false
    end

    describe 'in_check?' do

      it "should return false when this king is not in check" do
        expect king.in_check?.to eq(false)
      end

      it "should return true when this king is in check" do
        expect king.in_check?.to eq(true)
      end

    end
  end
end
