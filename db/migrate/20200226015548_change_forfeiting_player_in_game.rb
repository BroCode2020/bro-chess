class ChangeForfeitingPlayerInGame < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :forfeiting_player_id, :int
    remove_column :games, :forfeiting_player
  end
end
