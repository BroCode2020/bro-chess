require 'rails_helper'
RSpec::Matchers.define_negated_matcher :not_change, :change
RSpec.describe Pawn, type: :model do
  let(:game) { FactoryBot.create(:game) }
  let(:white_pawn) { FactoryBot.create(:pawn, color: 1, game: game, x_pos: 5, y_pos: 5) }
  let(:black_pawn) { FactoryBot.create(:pawn, color: 0, game: game, x_pos: 4, y_pos: 4) }
  
  describe '#valid_move?' do
    it 'should be able to move one field down if white' do
      expect(white_pawn.valid_move?(5, 4)).to eq true
    end
    it 'should not be able to move one field up if white' do
       expect(white_pawn.valid_move?(5, 6)).to eq false
    end
    it 'should be able to move one field up if black' do
      expect(black_pawn.valid_move?(4, 5)).to eq true
    end
    it 'should not be able to move one field down if black' do
       expect(black_pawn.valid_move?(4, 3)).to eq false
    end
    it 'should not be able to move if space is occupied' do
      FactoryBot.create(:pawn, color: 1, game: game, x_pos: 4, y_pos: 5)
      expect(black_pawn.valid_move?(4, 5)).to eq false
    end

    it 'should not be able to move one field left' do
      expect(white_pawn.valid_move?(6, 5)).to eq false
    end
    it 'should not be able to move one field right' do
      expect(white_pawn.valid_move?(4, 5)).to eq false
    end

    it 'should return true if it is a diagonal move taking piece' do

      FactoryBot.create(:pawn, color: 1, game: game, x_pos: 5, y_pos: 5)
      expect(black_pawn.valid_move?(5, 5)).to eq true
     
    end

    it 'should return false if it is a diagonal move taking piece of same color' do

      FactoryBot.create(:pawn, color: 0, game: game, x_pos: 5, y_pos: 5)
      expect(black_pawn.valid_move?(5, 5)).to eq false
     
    end

    it 'should return false if it is a diagonal move not taking a piece' do
      expect(black_pawn.valid_move?(5, 5)).to eq false
    end

    it 'should return false if it moves more than one field' do
      expect(white_pawn.valid_move?(7, 7)).to eq false
      expect(white_pawn.valid_move?(5, 4)).to eq true
    end
    
  end
end
