require 'rails_helper'

RSpec.describe GamesController, type: :controller do

  describe "POST games#move" do
      it "should move a piece" do
          game = FactoryBot.create(:game)
    	    p1 = game.pieces.create(x_pos: 0, y_pos: 0)
          expect(p1.x_pos).not_to eq(5)
          expect(p1.y_pos).not_to eq(5)
          post :move, params: {:id => game.id, :piece_id => p1.id, :x_pos => 5, :y_pos => 5}
          assert_redirected_to game_path(game.id)
          p1.reload
          expect(p1.x_pos).to eq(5)
          expect(p1.y_pos).to eq(5)
    end
  end
end
