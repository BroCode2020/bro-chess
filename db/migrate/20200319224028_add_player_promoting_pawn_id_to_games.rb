class AddPlayerPromotingPawnIdToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :pawn_promotion_player_id, :integer
  end
end
