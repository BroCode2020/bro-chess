class CreatePieces < ActiveRecord::Migration[5.2]
  def change
    create_table :pieces do |t|
      t.integer :x_pos
      t.integer :y_pos
      t.string :type
      t.boolean  :color
      t.integer :player_id
      t.integer :game_id
      t.datetime :created_at
      t.datetime :updated_at
      t.timestamps
    end
  end
end
