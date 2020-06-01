class AddPromotionPendingToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :promotion_pending, :boolean, default: false
    remove_column :games, :pawn_to_promote_color, :integer
  end
end
