class AddPawnToPromoteColorToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :pawn_to_promote_color, :integer
    remove_column :games, :pawn_promotion_player_id, :integer
  end
end
