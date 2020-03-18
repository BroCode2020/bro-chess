class AddGameStatusVariablesToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :game_ended, :boolean, default: false
    add_column :games, :game_tied, :boolean, default: false
    add_column :games, :victorious_player_id, :int
  end
end
