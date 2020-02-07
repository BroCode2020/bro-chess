require 'rails_helper'

RSpec.describe Game, type: :model do

  # Testing:		tile_is_occupied? (tile_x_position, tile_y_position)
  
  it "should return true for (0,0) when piece is at (x_pos: 0, y_pos: 0)" do

	game = FactoryBot.create(:game)
	game.pieces.create(x_pos: 0, y_pos: 0)
	expect(game.tile_is_occupied?(0,0)).to eq(true)

  end

  it "should return false for (1,1) when piece is at (x_pos: 0, y_pos: 0)" do

	game = FactoryBot.create(:game)
	game.pieces.create(x_pos: 0, y_pos: 0)
	expect(game.tile_is_occupied?(1,1)).to eq(false)

  end

  # Testing:		valid_input_target?(start_position_x, start_position_y, end_position_x, end_position_y)

  it "should return true for inputs that are horizonal" do

	game = FactoryBot.create(:game)
	p1 = game.pieces.create(x_pos: 0, y_pos: 0)
	p2 = game.pieces.create(x_pos: 5, y_pos: 0)

	# Utilize 'send' to allow testing of private method
	expect(game.send(:valid_input_target?, p1.x_pos, p1.y_pos, p2.x_pos, p2.y_pos)).to eq(true)
  end

  it "should return true for inputs that are vertical" do

	game = FactoryBot.create(:game)
	p1 = game.pieces.create(x_pos: 0, y_pos: 0)
	p2 = game.pieces.create(x_pos: 0, y_pos: 4)

	expect(game.send(:valid_input_target?, p1.x_pos, p1.y_pos, p2.x_pos, p2.y_pos)).to eq(true)
  end

  it "should return true for inputs that are diagonal" do

	game = FactoryBot.create(:game)
	p1 = game.pieces.create(x_pos: 1, y_pos: 1)
	p2 = game.pieces.create(x_pos: 0, y_pos: 2)

	expect(game.send(:valid_input_target?, p1.x_pos, p1.y_pos, p2.x_pos, p2.y_pos)).to eq(true)
  end

  it "should return false for inputs that are not horizonal, vertical, or diagonal" do

	game = FactoryBot.create(:game)
	p1 = game.pieces.create(x_pos: 0, y_pos: 0)
	p2 = game.pieces.create(x_pos: 2, y_pos: 4)

	expect(game.send(:valid_input_target?, p1.x_pos, p1.y_pos, p2.x_pos, p2.y_pos)).to eq(false)
  end

  it "should return true when targets are horizontally adjacent" do

	game = FactoryBot.create(:game)
	p1 = game.pieces.create(x_pos: 0, y_pos: 0)
	p2 = game.pieces.create(x_pos: 1, y_pos: 0)

	expect(game.send(:valid_input_target?, p1.x_pos, p1.y_pos, p2.x_pos, p2.y_pos)).to eq(true)
  end

  it "should return true when targets are vertically adjacent" do

	game = FactoryBot.create(:game)
	p1 = game.pieces.create(x_pos: 0, y_pos: 0)
	p2 = game.pieces.create(x_pos: 0, y_pos: 1)

	expect(game.send(:valid_input_target?, p1.x_pos, p1.y_pos, p2.x_pos, p2.y_pos)).to eq(true)
  end
	  
  it "should return true when targets are diagonally adjacent" do

	game = FactoryBot.create(:game)
	p1 = game.pieces.create(x_pos: 0, y_pos: 0)
	p2 = game.pieces.create(x_pos: 1, y_pos: 1)

	expect(game.send(:valid_input_target?, p1.x_pos, p1.y_pos, p2.x_pos, p2.y_pos)).to eq(true)
  end

  # Testing:		is_obstructed?(start_position_x, start_position_y, end_position_x, end_position_y)

  it "should return false when there are no pieces between two validly positioned targets" do

	game = FactoryBot.create(:game)
	p1 = game.pieces.create(x_pos: 0, y_pos: 0)
	p2 = game.pieces.create(x_pos: 3, y_pos: 0)

	expect(game.is_obstructed?(p1.x_pos, p1.y_pos, p2.x_pos, p2.y_pos)).to eq(false)
  end

  it "should return true when there are one or more pieces between between two validly positioned targets" do
		
	game = FactoryBot.create(:game)
	p1 = game.pieces.create(x_pos: 0, y_pos: 0)
	p2 = game.pieces.create(x_pos: 4, y_pos: 0)
	p3 = game.pieces.create(x_pos: 2, y_pos: 0)

	expect(game.is_obstructed?(p1.x_pos, p1.y_pos, p2.x_pos, p2.y_pos)).to eq(true)
  end

  it "should return an error when targets have invalid positioning (are not horizontal, vertical, or diagonal)" do

	game = FactoryBot.create(:game)
	p1 = game.pieces.create(x_pos: 0, y_pos: 0)
	p2 = game.pieces.create(x_pos: 1, y_pos: 3)

	expect {
		# Must use expect{...} rather than expect(...) for this this Rspec logic to work properly 
		game.is_obstructed?(p1.x_pos, p1.y_pos, p2.x_pos, p2.y_pos).to raise_error(RuntimeError, 'Invalid input detected. Input is not horizontal, vertical, or diagonal.')
	}
  end
  
end
