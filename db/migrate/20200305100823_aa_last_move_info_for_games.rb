class AaLastMoveInfoForGames < ActiveRecord::Migration[5.2]
  def change
 add_column :games, :last_moved_piece_id, :integer
 add_foreign_key "games", "pieces", name: "games_last_moved_piece_fk", column: "last_moved_piece_id"
 add_column :games, :last_moved_prev_x_pos, :integer
 add_column :games, :last_moved_prev_y_pos, :integer
 remove_column :games, :piece_capturable_by_en_passant, :string
end
  end
