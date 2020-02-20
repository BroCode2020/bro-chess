require 'rails_helper'

RSpec.describe Game, type: :model do

  # Testing:		tile_is_occupied? (tile_x_position, tile_y_position)

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

end
