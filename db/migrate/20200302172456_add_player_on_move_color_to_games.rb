class AddPlayerOnMoveColorToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :player_on_move_color, :integer, default: 1
  end
end
