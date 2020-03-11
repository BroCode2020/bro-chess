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
  end

  describe 'in_check?' do

    it "should return false when this king is not in check" do
      expect(king.in_check?).to eq(false)
    end

    it "should return true when this king is in check" do

      game_b = FactoryBot.create(:game)
      king_b = FactoryBot.create(:king, color: '0', game: game, x_pos: 4, y_pos: 4)
      queen_b = FactoryBot.create(:queen, color: '1', game: game, x_pos: 6, y_pos: 6)

      expect(king_b.in_check?).to eq(true)

    end

    it "should return false when this king is in a position that would be in check, except that the other piece is the same color" do

      game_b = FactoryBot.create(:game)
      king_b = FactoryBot.create(:king, color: '0', game: game, x_pos: 4, y_pos: 4)
      queen_b = FactoryBot.create(:queen, color: '0', game: game, x_pos: 6, y_pos: 6)

      expect(king_b.in_check?).to eq(false)

    end

  end

end
describe '#castle!' do
  let!(:game_c)  { FactoryBot.create(:game)}
  let!(:king_cw) { FactoryBot.create(:king, game: game_c, x_pos: 4, y_pos: 0, color: 1) }
  let!(:rook_cr) { FactoryBot.create(:rook, game: game_c, x_pos: 7, y_pos: 0, color: 1) }
  let!(:rook_cl) { FactoryBot.create(:rook, game: game_c, x_pos: 0, y_pos: 0, color: 1) }
  let!(:king_cb) { FactoryBot.create(:king, game: game_c, x_pos: 4, y_pos: 7, color: 0) }
  let!(:rook_crb) { FactoryBot.create(:rook, game: game_c, x_pos: 7, y_pos: 7, color: 0) }
  let!(:rook_clb) { FactoryBot.create(:rook, game: game_c, x_pos: 0, y_pos: 7, color: 0) }
   context 'white castle move is successful' do

     it 'castle king side king coords update' do
       game_b = FactoryBot.create(:game)
       game_b.pieces.clear
       king_cw = FactoryBot.create(:king, color: 1, game: game_b, x_pos: 4, y_pos: 0)
       rook_cr = FactoryBot.create(:rook, color: 1, game: game_b, x_pos: 0, y_pos: 0)
       rook_cl = FactoryBot.create(:rook, color: 1, game: game_b, x_pos: 7, y_pos: 0)
       king_cw.move_to!(6, 0)
       expect(king_cw).to have_attributes(x_pos: 6, y_pos: 0)


     end
     it 'castle king side rook coords update' do
       game_b = FactoryBot.create(:game)
       game_b.pieces.clear
       king_cw = FactoryBot.create(:king, color: 1, game: game_b, x_pos: 4, y_pos: 0)
       rook_cl = FactoryBot.create(:rook, color: 1, game: game_b, x_pos: 0, y_pos: 0)
       rook_cr = FactoryBot.create(:rook, color: 1, game: game_b, x_pos: 7, y_pos: 0)
       king_cw.castle!(7, 0)
       rook_cr.reload
       expect(rook_cr).to have_attributes(x_pos: 5, y_pos: 0)
     end
     it 'castle queen side king coords update' do
       game_b = FactoryBot.create(:game)
       game_b.pieces.clear
       king_cw = FactoryBot.create(:king, color: 1, game: game_b, x_pos: 4, y_pos: 0)
       rook_cl = FactoryBot.create(:rook, color: 1, game: game_b, x_pos: 0, y_pos: 0)
       rook_cr = FactoryBot.create(:rook, color: 1, game: game_b, x_pos: 7, y_pos: 0)
       king_cw.castle!(0, 0)
       expect(king_cw).to have_attributes(x_pos: 2, y_pos: 0)
     end
     it 'castle queen side rook coords update' do
       game_b = FactoryBot.create(:game)
       game_b.pieces.clear
       king_cw = FactoryBot.create(:king, color: 1, game: game_b, x_pos: 4, y_pos: 0)
       rook_cl = FactoryBot.create(:rook, color: 1, game: game_b, x_pos: 0, y_pos: 0)
       rook_cr = FactoryBot.create(:rook, color: 1, game: game_b, x_pos: 7, y_pos: 0)
       king_cw.castle!(0, 0)
       rook_cl.reload
       expect(rook_cl).to have_attributes(x_pos: 3, y_pos: 0)
     end
   end
   context 'black castle move is successful' do

     it 'castle king side king coords update' do
       game_b = FactoryBot.create(:game)
       game_b.pieces.clear
       king_cb = FactoryBot.create(:king, color: 0, game: game_b, x_pos: 4, y_pos: 7)
       rook_clb = FactoryBot.create(:rook, color: 0, game: game_b, x_pos: 0, y_pos: 7)
       rook_crb = FactoryBot.create(:rook, color: 0, game: game_b, x_pos: 7, y_pos: 7)
       king_cb.castle!(7, 7)
       expect(king_cb).to have_attributes(x_pos: 6, y_pos: 7)
     end
     it 'castle king side rook coords update' do
       game_b = FactoryBot.create(:game)
       game_b.pieces.clear
       king_cb = FactoryBot.create(:king, color: 0, game: game_b, x_pos: 4, y_pos: 7)
       rook_clb = FactoryBot.create(:rook, color: 0, game: game_b, x_pos: 0, y_pos: 7)
       rook_crb = FactoryBot.create(:rook, color: 0, game: game_b, x_pos: 7, y_pos: 7)
       king_cb.castle!(7, 7)
       rook_crb.reload
       expect(rook_crb).to have_attributes(x_pos: 5, y_pos: 7)
     end
     it 'castle queen side king coords update' do
       game_b = FactoryBot.create(:game)
       game_b.pieces.clear
       king_cb = FactoryBot.create(:king, color: 0, game: game_b, x_pos: 4, y_pos: 7)
       rook_clb = FactoryBot.create(:rook, color: 0, game: game_b, x_pos: 0, y_pos: 7)
       rook_crb = FactoryBot.create(:rook, color: 0, game: game_b, x_pos: 7, y_pos: 7)
       king_cb.castle!(0, 7)
       expect(king_cb).to have_attributes(x_pos: 2, y_pos: 7)
     end
     it 'castle queen side rook coords update' do
       game_b = FactoryBot.create(:game)
       game_b.pieces.clear
       king_cb = FactoryBot.create(:king, color: 0, game: game_b, x_pos: 4, y_pos: 7)
       rook_clb = FactoryBot.create(:rook, color: 0, game: game_b, x_pos: 0, y_pos: 7)
       rook_crb = FactoryBot.create(:rook, color: 0, game: game_b, x_pos: 7, y_pos: 7)
       king_cb.castle!(0, 7)
       rook_clb.reload
       expect(rook_clb).to have_attributes(x_pos: 3, y_pos: 7)
     end
   end
   context 'black castle move returns false' do
     let!(:bishop_crb) { FactoryBot.create(:bishop, game: game_c, x_pos: 5, y_pos: 7, color: 0) }
     let!(:bishop_clb) { FactoryBot.create(:bishop, game: game_c, x_pos: 2, y_pos: 7, color: 0) }
     it 'castle king side coords do not update' do
       expect { king_cb.castle!(7, 7) }.to raise_error('Invalid move')
         .and not_change(king_cb, :x_pos)
         .and not_change(king_cb, :y_pos)
         .and not_change(rook_crb, :x_pos)
         .and not_change(rook_crb, :y_pos)
     end
     it 'castle queen side coords do not update' do
       expect { king_cb.castle!(0, 7) }.to raise_error('Invalid move')
         .and not_change(king_cb, :x_pos)
         .and not_change(king_cb, :y_pos)
         .and not_change(rook_clb, :x_pos)
         .and not_change(rook_clb, :y_pos)
     end
   end
 end

describe '#castle?' do
    let!(:game_c)  { FactoryBot.create(:game) }
    let!(:king_cw) { FactoryBot.create(:king, game: game_c, x_pos: 4, y_pos: 0, color: 1) }
    let!(:rook_cr) { FactoryBot.create(:rook, game: game_c, x_pos: 7, y_pos: 0, color: 1) }
    let!(:rook_cl) { FactoryBot.create(:rook, game: game_c, x_pos: 0, y_pos: 0, color: 1) }
    let!(:king_cb) { FactoryBot.create(:king, game: game_c, x_pos: 2, y_pos: 7, color: 0) }
    context 'neither piece has moved' do
      it 'returns true to the right rook' do
        game_b = FactoryBot.create(:game)
   			game_b.pieces.clear
   			king_b = FactoryBot.create(:king, color: 1, game: game_b, x_pos: 4, y_pos: 0)
        rook_qs = FactoryBot.create(:rook, color: 1, game: game_b, x_pos: 0, y_pos: 0)
        rook_ks = FactoryBot.create(:rook, color: 1, game: game_b, x_pos: 7, y_pos: 0)

        expect(king_b.castle?(7, 0)).to eq true
      end
      it 'returns true to left rook' do
        game_b = FactoryBot.create(:game)
        game_b.pieces.clear
        king_b = FactoryBot.create(:king, color: 1, game: game_b, x_pos: 4, y_pos: 0)
        rook_qs = FactoryBot.create(:rook, color: 1, game: game_b, x_pos: 0, y_pos: 0)
        rook_ks = FactoryBot.create(:rook, color: 1, game: game_b, x_pos: 7, y_pos: 0)

        expect(king_b.castle?(7, 0)).to eq true
      end
    end
    context 'king has moved' do
      it 'castle king side returns false' do
        king_cw.move_to!(5, 0)
        expect(king_cw).to have_attributes(moved?: true)
        expect(king_cw.castle?(7, 0)).to eq false
      end
      it 'castle queen side returns false' do
        king_cw.move_to!(5, 0)
        expect(king_cw.castle?(0, 0)).to eq false
      end
    end
    context 'right rook has moved' do
      it 'returns false to right rook' do
        rook_cr.move_to!(6, 0)
        expect(king_cw.castle?(6, 0)).to eq false
      end
      it 'returns true to left rook' do
        game_b = FactoryBot.create(:game)
        game_b.pieces.clear
        king_b = FactoryBot.create(:king, color: 1, game: game_b, x_pos: 4, y_pos: 0)
        rook_qs = FactoryBot.create(:rook, color: 1, game: game_b, x_pos: 0, y_pos: 0)
        rook_ks = FactoryBot.create(:rook, color: 1, game: game_b, x_pos: 7, y_pos: 0)
        rook_cr.move_to!(6, 0)
        expect(king_b.castle?(7, 0)).to eq true
      end
        context 'piece is between rook and castle' do
            it 'returns false' do
              FactoryBot.create(:bishop, game: game_c, x_pos: 5, y_pos: 0, color: 1)
              expect(king_cw.castle?(7, 0)).to eq false
            end
          end

          context 'game is in check' do
            it 'returns false' do
              game_b = FactoryBot.create(:game)
              game_b.pieces.clear
              king_b = FactoryBot.create(:king, color: 1, game: game_b, x_pos: 4, y_pos: 0)
              rook_qs = FactoryBot.create(:rook, color: 1, game: game_b, x_pos: 0, y_pos: 0)
              rook_ks = FactoryBot.create(:rook, color: 1, game: game_b, x_pos: 7, y_pos: 0)
              queen_b =  FactoryBot.create(:queen, color: 0, game: game_b, x_pos: 4, y_pos: 3)
              expect(king_b.castle?(7, 0)).to eq false
            end
          end
          context 'king moves through space in check' do
            it 'returns false' do
              game_b = FactoryBot.create(:game)
              game_b.pieces.clear
              king_b = FactoryBot.create(:king, color: 1, game: game_b, x_pos: 4, y_pos: 0)
              rook_qs = FactoryBot.create(:rook, color: 1, game: game_b, x_pos: 0, y_pos: 0)
              rook_ks = FactoryBot.create(:rook, color: 1, game: game_b, x_pos: 7, y_pos: 0)
              queen_b =  FactoryBot.create(:queen, color: 0, game: game_b, x_pos: 4, y_pos: 3)
              expect(king_b.castle?(7, 0)).to eq false
            end
          end
          context 'castling results in check' do
            it 'returns false' do
              game_b = FactoryBot.create(:game)
              game_b.pieces.clear
              king_b = FactoryBot.create(:king, color: 1, game: game_b, x_pos: 4, y_pos: 0)
              rook_qs = FactoryBot.create(:rook, color: 1, game: game_b, x_pos: 0, y_pos: 0)
              rook_ks = FactoryBot.create(:rook, color: 1, game: game_b, x_pos: 7, y_pos: 0)
              queen_b =  FactoryBot.create(:queen, color: 0, game: game_b, x_pos: 4, y_pos: 3)
              expect(king_b.castle?(7, 0)).to eq false
            end
          end
        end
      end
