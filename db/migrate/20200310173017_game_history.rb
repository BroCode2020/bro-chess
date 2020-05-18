class GameHistory < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :user_id, :integer
    add_index :games, :user_id

    add_column :users, :game_id, :integer
    add_index :users, :game_id
  end
end
