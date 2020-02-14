class Piece < ApplicationRecord
  belongs_to :game


  def position
    "#{self.x_pos}, #{self.y_pos}"
  end



  def move_to!(new_x, new_y)

		piece_to_capture = self.game.pieces.where(:x_pos => new_x, :y_pos => new_y).first
		if piece_to_capture.present? && self.color.to_i != piece_to_capture.color.to_i
			piece_to_capture.update_attributes(:x_pos => nil, :y_pos => nil) #captured pieces are nil thus not drawn and not clickable
			self.update_attributes(:x_pos => new_x, :y_pos => new_y)
		elsif piece_to_capture.present? && self.color.to_i == piece_to_capture.color
      return false
    else
      self.update_attributes({:x_pos => new_x, :y_pos => new_y})
    end
    return true
	end




end
