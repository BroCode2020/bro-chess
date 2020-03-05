require 'rails_helper'
RSpec::Matchers.define_negated_matcher :not_change, :change
RSpec.describe Pawn, type: :model do
  let(:game) { FactoryBot.create(:game) }
  let(:white_pawn) { FactoryBot.create(:pawn, color: 1, game: game, x_pos: 5, y_pos: 3) }
  let(:black_pawn) { FactoryBot.create(:pawn, color: 0, game: game, x_pos: 4, y_pos: 4) }

  describe '#valid_move?' do
    it 'should be able to move one field down if white' do
      expect(white_pawn.move_to!(5, 4)).to eq true
    end
    it 'should not be able to move one field up if white' do
      pawn = FactoryBot.create(:pawn, color: 1, game: game, x_pos: 5, y_pos: 5)
      expect(pawn.valid_move?(5, 4)).to eq false
    end
    it 'should be able to move one field up if black' do
      expect(black_pawn.valid_move?(4, 3)).to eq true
    end
    it 'should be able to move one field down if white' do
      expect(white_pawn.valid_move?(5, 4)).to eq true
    end
    it 'should not be able to move one field down if black' do
       expect(black_pawn.move_to!(4, 5)).to eq false
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
      FactoryBot.create(:pawn, color: 1, game: game, x_pos: 5, y_pos: 3)
      expect(black_pawn.valid_move?(5, 3)).to eq true

    end

    it 'should return false if it is a diagonal move taking piece of same color' do
      FactoryBot.create(:pawn, color: 0, game: game, x_pos: 3, y_pos: 3)
      expect(black_pawn.valid_move?(3, 3)).to eq false

    end

    it 'should return false if it is a diagonal move not taking a piece' do
      expect(black_pawn.valid_move?(5, 5)).to eq false
    end

    it 'should return false if it moves more than one field' do
      expect(white_pawn.valid_move?(5, 5)).to eq false
    end

    it 'should be able to move two fields if it hasn not moved yet' do
      pawn = game.pieces.where(x_pos: 0, y_pos: 1).first
      expect(pawn.valid_move?(0, 3)).to eq true
    end

    it 'should never be able to move more than 2 fields even at start' do
      pawn = game.pieces.where(x_pos: 0, y_pos: 1).first
      expect(pawn.valid_move?(0, 4)).to eq false
    end
  end

  describe '#has_moved?' do
    it "should return false if white and in the second row" do
       pawn = FactoryBot.create(:pawn, color: 1, game: game, x_pos: 0, y_pos: 1)
       expect(pawn.has_moved?).to eq false
    end

    it "should return true if white and not in the second row" do
      pawn = FactoryBot.create(:pawn, color: 1, game: game, x_pos: 0, y_pos: 2)
      expect(pawn.has_moved?).to eq true
    end

    it "should return false if black and in the seventh row" do
      pawn = FactoryBot.create(:pawn, color: 0, game: game, x_pos: 0, y_pos: 6)
       expect(pawn.has_moved?).to eq false
    end

    it "should return true if black and not in the seventh row" do
      pawn = FactoryBot.create(:pawn, color: 0, game: game, x_pos: 0, y_pos: 5)
      expect(pawn.has_moved?).to eq true
    end
  end
end

describe '#en_passant?' do
  let(:game) { FactoryBot.create(:game) }
  let(:pawn_en_passant) { FactoryBot.create(:pawn, color: 1, game: game, x_pos: 0, y_pos: 4) }
  let(:black_pawn) { FactoryBot.create(:pawn, color: 0, game: game, x_pos: 1, y_pos: 6) }
  let(:pawn_white) { FactoryBot.create(:pawn, color: 0, game: game, x_pos: 1, y_pos: 1) }

it 'should be able to move en passant if en passant situation' do
   expect(black_pawn.move_to!(1, 4)).to eq true
    pawn_en_passant.move_to!(1, 5)
    (pawn_en_passant.move_to!(1, 5))
    expect(pawn_en_passant).to have_attributes(x_pos: 1, y_pos: 5)
 end

 it 'should capture the piece if moving en passant' do
   pawn_en_passant
   black_pawn.move_to!(1, 4)
   pawn_en_passant.move_to!(1, 5)
   black_pawn.reload
   expect(black_pawn).to have_attributes(x_pos: nil, y_pos: nil)
 end
 it 'should not move if no en passant situation and trying to move en passant' do
   pawn_en_passant.move_to!(1, 5)
   expect(pawn_en_passant.valid_move?(1, 5)).to eq false
 end
 it 'should not move en passant if the last move was not a two step pawn move which created en passant situation' do
   black_pawn2 = FactoryBot.create(:pawn, color: 'black', x_pos: 6, y_pos: 6, game: game)
   black_pawn.move_to!(1, 4)
   pawn_white.move_to!(1, 3)
   black_pawn2.move_to!(6, 4)
   pawn_en_passant.move_to!(1, 5)
   expect(pawn_en_passant.valid_move?(1, 5)).to eq false
 end
end
