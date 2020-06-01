class ChangeUsersAddGameStats < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :games_won, :int, default: 0
    add_column :users, :games_lost, :int, default: 0
    add_column :users, :games_drawn, :int, default: 0
  end
end
