require 'rails_helper'

RSpec.describe Piece, type: :model do

  #color true = white
  it "should return color" do
    game = FactoryBot.create(:game)
  	white_piece = game.pieces.create(x_pos: 0, y_pos: 0, color: true)
    black_piece = game.pieces.create(x_pos: 1, y_pos: 0, color: false)
  	expect(white_piece.color).to eq(1)
    expect(black_piece.color).to eq(0)
  end

  #testing move_to!
  it "should return true when a piece moves to an empty tile" do
    game = FactoryBot.create(:game)
    white_piece = game.pieces.create(x_pos: 0, y_pos: 0, color: true)
    black_piece = game.pieces.create(x_pos: 4, y_pos: 0, color: false)
    expect(white_piece.move_to!(1,0)).to eq(true)
  end

  it "should return false when trying to move to a tile occupied by a piece of same color" do
    game = FactoryBot.create(:game)
    white_piece = game.pieces.create(x_pos: 0, y_pos: 0, color: true)
    white_piece_2 = game.pieces.create(x_pos: 1, y_pos: 0, color: true)
    expect(white_piece.move_to!(1,0)).to eq(false)
  end

  it "should return true when moving to a tile with a piece of opposite color and update captured piece to position nil, nil" do
    game = FactoryBot.create(:game)
    white_piece = game.pieces.create(x_pos: 0, y_pos: 0, color: true)
    black_piece = game.pieces.create(x_pos: 1, y_pos: 0, color: false)
    expect(white_piece.move_to!(1,0)).to eq(true)
    white_piece.reload
    black_piece.reload
    expect(white_piece.x_pos).to eq(1)
    expect(white_piece.y_pos).to eq(0)
    expect(black_piece.x_pos).to eq(nil)
    expect(black_piece.y_pos).to eq(nil)
  end

  #testing position
  it "should return a correctly formatted position string" do
    game = FactoryBot.create(:game)
    piece = game.pieces.create(x_pos: 1, y_pos: 2)
    expect(piece.position).to eq("1, 2")
  end



end
