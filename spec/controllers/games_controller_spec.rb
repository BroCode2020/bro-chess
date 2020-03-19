require 'rails_helper'

RSpec.describe GamesController, type: :controller do

  describe "POST games#move" do
    it "should move a piece" do
      game = FactoryBot.create(:game)
      game.pieces.clear
      p1 = FactoryBot.create(:queen, x_pos: 0, y_pos: 0, color: 0, game: game)
      p2 = FactoryBot.create(:king, x_pos: 0, y_pos: 7, color: 0, game: game)
      p3 = FactoryBot.create(:king, x_pos: 7, y_pos: 1, color: 1, game: game)
      expect(p1.x_pos).not_to eq(5)
      expect(p1.y_pos).not_to eq(5)
      post :move, params: {:id => game.id, :piece_id => p1.id, :x_pos => 5, :y_pos => 5}
      assert_redirected_to game_path(game.id)
      p1.reload
      expect(p1.x_pos).to eq(5)
      expect(p1.y_pos).to eq(5)
    end

    it "should not move a piece if it results in moving player being in check" do
      game = FactoryBot.create(:game)
      game.pieces.clear
      p1 = FactoryBot.create(:queen, x_pos: 0, y_pos: 3, color: 0, game: game)
      p2 = FactoryBot.create(:king, x_pos: 0, y_pos: 0, color: 0, game: game)
      p3 = FactoryBot.create(:queen, x_pos: 0, y_pos: 7, color: 1, game: game)
      p4 = FactoryBot.create(:king, x_pos: 7, y_pos: 1, color: 1, game: game)
      expect(p1.x_pos).not_to eq(2)
      expect(p1.y_pos).not_to eq(5)
      post :move, params: {:id => game.id, :piece_id => p1.id, :x_pos => 3, :y_pos => 3}
      assert_redirected_to game_path(game.id)
      p1.reload
      expect(p1.x_pos).not_to eq(2)
      expect(p1.y_pos).not_to eq(5)
    end
  end
end
