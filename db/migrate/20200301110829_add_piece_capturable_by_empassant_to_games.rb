class AddPieceCapturableByEmpassantToGames < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :piece_capturable_by_en_passant, :string
  end
end
