require 'rails_helper'

RSpec.describe Game, type: :model do

  # Testing:		tile_is_occupied? (tile_x_position, tile_y_position)
  
  it "should return true for (0,0) when piece is at (x_pos: 0, y_pos: 0)" do

	p = FactoryBot.create(:piece)
	p.x_pos = 0
	p.y_pos = 0

	game = FactoryBot.create(:game)
	Games = [game]
	Users = [ FactoryBot.create(:user) ]
	game.pieces = [p]

	expect(game.tile_is_occupied?(0,0)).to eq(true)
  end

  it "should return false for (1,1) when piece is at (x_pos: 0, y_pos: 0)" do

	p = FactoryBot.create(:piece)
	p.x_pos = 0
	p.y_pos = 0

	game = FactoryBot.create(:game)
	Games = [game]
	Users = [ FactoryBot.create(:user) ]
	game.pieces = [p]

	expect(game.tile_is_occupied?(1,1)).to eq(false)
  end

  # Testing:		valid_input_target?(start_position_x, start_position_y, end_position_x, end_position_y)

  it "should return true for inputs that are horizonal" do

	p1 = FactoryBot.create(:piece)
	p1.x_pos = 0
	p1.y_pos = 0

	p2 = FactoryBot.create(:piece)
	p2.x_pos = 5
	p2.y_pos = 0

	game = FactoryBot.create(:game)
	Games = [game]
	Users = [ FactoryBot.create(:user) ]
	game.pieces = [p1, p2]

	# Utilize 'send' to allow testing of private method

	expect(game.send(:valid_input_target?, p1.x_pos, p1.y_pos, p2.x_pos, p2.y_pos)).to eq(true)
  end

  it "should return true for inputs that are vertical" do

	p1 = FactoryBot.create(:piece)
	p1.x_pos = 0
	p1.y_pos = 0

	p2 = FactoryBot.create(:piece)
	p2.x_pos = 0
	p2.y_pos = 4

	game = FactoryBot.create(:game)
	Games = [game]
	Users = [ FactoryBot.create(:user) ]
	game.pieces = [p1, p2]

	expect(game.send(:valid_input_target?, p1.x_pos, p1.y_pos, p2.x_pos, p2.y_pos)).to eq(true)
  end

  it "should return true for inputs that are diagonal" do

	p1 = FactoryBot.create(:piece)
	p1.x_pos = 1
	p1.y_pos = 1

	p2 = FactoryBot.create(:piece)
	p2.x_pos = 0
	p2.y_pos = 2

	game = FactoryBot.create(:game)
	Games = [game]
	Users = [ FactoryBot.create(:user) ]
	game.pieces = [p1, p2]

	expect(game.send(:valid_input_target?, p1.x_pos, p1.y_pos, p2.x_pos, p2.y_pos)).to eq(true)
  end

  it "should return false for inputs that are not horizonal, vertical, or diagonal" do

	p1 = FactoryBot.create(:piece)
	p1.x_pos = 0
	p1.y_pos = 0

	p2 = FactoryBot.create(:piece)
	p2.x_pos = 2
	p2.y_pos = 4

	game = FactoryBot.create(:game)
	Games = [game]
	Users = [ FactoryBot.create(:user) ]
	game.pieces = [p1, p2]

	expect(game.send(:valid_input_target?, p1.x_pos, p1.y_pos, p2.x_pos, p2.y_pos)).to eq(false)
  end

  it "should return true when targets are horizontally adjacent" do
	p1 = FactoryBot.create(:piece)
	p1.x_pos = 0
	p1.y_pos = 0

	p2 = FactoryBot.create(:piece)
	p2.x_pos = 1
	p2.y_pos = 0

	game = FactoryBot.create(:game)
	Games = [game]
	Users = [ FactoryBot.create(:user) ]
	game.pieces = [p1, p2]

	expect(game.send(:valid_input_target?, p1.x_pos, p1.y_pos, p2.x_pos, p2.y_pos)).to eq(true)
  end

  it "should return true when targets are vertically adjacent" do
	p1 = FactoryBot.create(:piece)
	p1.x_pos = 0
	p1.y_pos = 0

	p2 = FactoryBot.create(:piece)
	p2.x_pos = 0
	p2.y_pos = 1

	game = FactoryBot.create(:game)
	Games = [game]
	Users = [ FactoryBot.create(:user) ]
	game.pieces = [p1, p2]

	expect(game.send(:valid_input_target?, p1.x_pos, p1.y_pos, p2.x_pos, p2.y_pos)).to eq(true)
  end
	  
  it "should return true when targets are diagonally adjacent" do
	p1 = FactoryBot.create(:piece)
	p1.x_pos = 0
	p1.y_pos = 0

	p2 = FactoryBot.create(:piece)
	p2.x_pos = 1
	p2.y_pos = 1

	game = FactoryBot.create(:game)
	Games = [game]
	Users = [ FactoryBot.create(:user) ]
	game.pieces = [p1, p2]

	expect(game.send(:valid_input_target?, p1.x_pos, p1.y_pos, p2.x_pos, p2.y_pos)).to eq(true)
  end

  # Testing:		is_obstructed?(start_position_x, start_position_y, end_position_x, end_position_y)

  it "should return false when there are no pieces between two validly positioned targets" do
	p1 = FactoryBot.create(:piece)
	p1.x_pos = 0	
	p1.y_pos = 0

	p2 = FactoryBot.create(:piece)	
	p2.x_pos = 3	
	p2.y_pos = 0
	
	game = FactoryBot.create(:game)
	Games = [game]	
	Users = [ FactoryBot.create(:user) ]	
	game.pieces = [p1, p2]
	
	expect(game.is_obstructed?(p1.x_pos, p1.y_pos, p2.x_pos, p2.y_pos)).to eq(false)
  end

  it "should return true when there are one or more pieces between between two validly positioned targets" do
		
	p1 = FactoryBot.create(:piece)	
	p1.x_pos = 0	
	p1.y_pos = 0
	
	p2 = FactoryBot.create(:piece)
	p2.x_pos = 4
	p2.y_pos = 0

	p3 = FactoryBot.create(:piece)	
	p3.x_pos = 2	
	p3.y_pos = 0
		
	game = FactoryBot.create(:game)
	Games = [game]
	Users = [ FactoryBot.create(:user) ]	
	game.pieces = [p1, p2, p3]
	
	expect(game.is_obstructed?(p1.x_pos, p1.y_pos, p2.x_pos, p2.y_pos)).to eq(true)
  end

  it "should return an error when targets have invalid positioning (are not horizontal, vertical, or diagonal)" do
	p1 = FactoryBot.create(:piece)
	p1.x_pos = 0
	p1.y_pos = 0

	p2 = FactoryBot.create(:piece)
	p2.x_pos = 1
	p2.y_pos = 3

	game = FactoryBot.create(:game)
	Games = [game]
	Users = [ FactoryBot.create(:user) ]
	game.pieces = [p1, p2]

	expect {
		# Must use expect{...} rather than expect(...) for this this Rspec logic to work properly 
		game.is_obstructed?(p1.x_pos, p1.y_pos, p2.x_pos, p2.y_pos).to raise_error(RuntimeError, 'Invalid input detected. Input is not horizontal, vertical, or diagonal.')
	}
  end
  
end
