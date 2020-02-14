class Piece < ApplicationRecord
  belongs_to :game

  def move_to!(new_x, new_y)
		captured = self.game.pieces.where(:x_pos => new_x, :y_pos => new_y).first
		if captured.present? && self.color != captured.color
			captured.update_attributes(:x_pos => nil, :y_pos => nil)
			self.update_attributes(:x_pos => new_x, :y_pos => new_y)
		elsif captured.present? && self.color == captured.color
      return false
    else
      self.update_attributes({:x_pos => new_x, :y_pos => new_y})
    end
    return true
	end


end
