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
    game.pieces.clear
    white_piece = game.pieces.create(x_pos: 0, y_pos: 0, color: true)
    black_piece = game.pieces.create(x_pos: 4, y_pos: 0, color: false)
    expect(white_piece.move_to!(1,0)).to eq(true)
  end

  it "should return false when trying to move to a tile occupied by a piece of same color" do
    game = FactoryBot.create(:game)
    game.pieces.clear
    white_piece = game.pieces.create(x_pos: 0, y_pos: 0, color: true)
    white_piece_2 = game.pieces.create(x_pos: 1, y_pos: 0, color: true)
    expect(white_piece.move_to!(1,0)).to eq(false)
  end

  it "should return true when moving to a tile with a piece of opposite color and update captured piece to position nil, nil" do
    game = FactoryBot.create(:game)
    game.pieces.clear
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


  # Testing:		valid_general_input_target?(start_position_x, start_position_y, end_position_x, end_position_y)

  it "should return true for inputs that are horizonal" do

    game = FactoryBot.create(:game)
    game.pieces.clear
    p1 = game.pieces.create(x_pos: 0, y_pos: 0)
    p2 = game.pieces.create(x_pos: 5, y_pos: 0)

    # Utilize 'send' to allow testing of private method
    expect(p1.send(:valid_general_input_target?, p1.x_pos, p1.y_pos, p2.x_pos, p2.y_pos)).to eq(true)
    end

    it "should return true for inputs that are vertical" do

    game = FactoryBot.create(:game)
    game.pieces.clear
    p1 = game.pieces.create(x_pos: 0, y_pos: 0)
    p2 = game.pieces.create(x_pos: 0, y_pos: 4)

    expect(p1.send(:valid_general_input_target?, p1.x_pos, p1.y_pos, p2.x_pos, p2.y_pos)).to eq(true)
    end

    it "should return true for inputs that are diagonal" do

    game = FactoryBot.create(:game)
    game.pieces.clear
    p1 = game.pieces.create(x_pos: 1, y_pos: 1)
    p2 = game.pieces.create(x_pos: 0, y_pos: 2)

    expect(p1.send(:valid_general_input_target?, p1.x_pos, p1.y_pos, p2.x_pos, p2.y_pos)).to eq(true)
    end

    it "should return false for inputs that are not horizonal, vertical, or diagonal" do

    game = FactoryBot.create(:game)
    game.pieces.clear
    p1 = game.pieces.create(x_pos: 0, y_pos: 0)
    p2 = game.pieces.create(x_pos: 2, y_pos: 4)

    expect(p1.send(:valid_general_input_target?, p1.x_pos, p1.y_pos, p2.x_pos, p2.y_pos)).to eq(false)
    end

    it "should return true when targets are horizontally adjacent" do

    game = FactoryBot.create(:game)
    game.pieces.clear
    p1 = game.pieces.create(x_pos: 0, y_pos: 0)
    p2 = game.pieces.create(x_pos: 1, y_pos: 0)

    expect(p1.send(:valid_general_input_target?, p1.x_pos, p1.y_pos, p2.x_pos, p2.y_pos)).to eq(true)
    end

    it "should return true when targets are vertically adjacent" do

    game = FactoryBot.create(:game)
    game.pieces.clear
    p1 = game.pieces.create(x_pos: 0, y_pos: 0)
    p2 = game.pieces.create(x_pos: 0, y_pos: 1)

    expect(p1.send(:valid_general_input_target?, p1.x_pos, p1.y_pos, p2.x_pos, p2.y_pos)).to eq(true)
    end

    it "should return true when targets are diagonally adjacent" do

    game = FactoryBot.create(:game)
    game.pieces.clear
    p1 = game.pieces.create(x_pos: 0, y_pos: 0)
    p2 = game.pieces.create(x_pos: 1, y_pos: 1)

    expect(p1.send(:valid_general_input_target?, p1.x_pos, p1.y_pos, p2.x_pos, p2.y_pos)).to eq(true)
    end


    # Testing:		is_obstructed?(start_position_x, start_position_y, end_position_x, end_position_y)

    it "should return false when there are no pieces between two validly positioned targets" do

    game = FactoryBot.create(:game)
    game.pieces.clear
    p1 = game.pieces.create(x_pos: 0, y_pos: 0)
    p2 = game.pieces.create(x_pos: 3, y_pos: 0)

    expect(p1.is_obstructed?(p1.x_pos, p1.y_pos, p2.x_pos, p2.y_pos)).to eq(false)
    end

    it "should return false when there are no pieces between two validly positioned targets" do

      game = FactoryBot.create(:game)
      game.pieces.clear
      p1 = game.pieces.create(x_pos: 0, y_pos: 0)
      p2 = game.pieces.create(x_pos: 1, y_pos: 0)

      expect(p1.is_obstructed?(p1.x_pos, p1.y_pos, p2.x_pos, p2.y_pos)).to eq(false)
      end

    it "should return true when there are one or more pieces between between two validly positioned targets" do

    game = FactoryBot.create(:game)
    game.pieces.clear
    p1 = game.pieces.create(x_pos: 0, y_pos: 0)
    p2 = game.pieces.create(x_pos: 4, y_pos: 0)
    p3 = game.pieces.create(x_pos: 2, y_pos: 0)

    expect(p1.is_obstructed?(p1.x_pos, p1.y_pos, p2.x_pos, p2.y_pos)).to eq(true)
    end

    it "should return an error when targets have invalid positioning (are not horizontal, vertical, or diagonal)" do

    game = FactoryBot.create(:game)
    game.pieces.clear
    p1 = game.pieces.create(x_pos: 0, y_pos: 0)
    p2 = game.pieces.create(x_pos: 1, y_pos: 3)

    expect {
      # Must use expect{...} rather than expect(...) for this this Rspec logic to work properly
      p1.is_obstructed?(p1.x_pos, p1.y_pos, p2.x_pos, p2.y_pos).to raise_error(RuntimeError, 'Invalid input detected. Input is not horizontal, vertical, or diagonal.')
    }
    end

end
