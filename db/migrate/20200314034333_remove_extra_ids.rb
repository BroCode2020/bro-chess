class RemoveExtraIds < ActiveRecord::Migration[5.2]
  def change
    remove_index :games, :user_id
    remove_column :games, :user_id, :integer
    
    remove_index :users, :game_id
    remove_column :users, :game_id, :integer
  end
end
