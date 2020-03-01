class AddForfeitingPlayerToGame < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :forfeiting_player, :int
  end
end
