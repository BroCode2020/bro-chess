class ChangeGamesUpdateBlackPlayerId < ActiveRecord::Migration[5.2]
  def change
    change_table :games do |t|
      t.remove :black_payer_id
      t.integer :black_player_id
    end
  end
end
