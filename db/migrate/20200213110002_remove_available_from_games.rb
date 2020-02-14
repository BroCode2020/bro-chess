class RemoveAvailableFromGames < ActiveRecord::Migration[5.2]
  def change
    remove_column :games, :available, :boolean
  end
end
