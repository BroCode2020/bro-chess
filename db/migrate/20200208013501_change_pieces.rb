class ChangePieces < ActiveRecord::Migration[5.2]
  def change
    change_table :pieces do |t|
      t.remove :player_id
      t.integer :color
    end
  end
end
