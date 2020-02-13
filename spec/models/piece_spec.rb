require 'rails_helper'

RSpec.describe Piece, type: :model do
  it "should return true when piece moves" do
    game = FactoryBot.create(:game)
  	game.pieces.create(x_pos: 0, y_pos: 0)
  	expect(game.tile_is_occupied?(0,0)).to eq(true)
end
