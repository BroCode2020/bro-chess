class AddImageToPieces < ActiveRecord::Migration[5.2]
  def change
    change_table :pieces do |t|
      t.string :image
  end
end
