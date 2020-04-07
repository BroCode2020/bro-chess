class King < Piece
  def valid_move?(new_x, new_y)
    $stderr.puts 'marker 0' if new_x == 6 && new_y == 0
    return false if new_y > 7 || new_x > 7 || new_y < 0 || new_x < 0
    $stderr.puts 'marker 1' if new_x == 6 && new_y == 0
    return false if new_y == y_pos && new_x == x_pos
    $stderr.puts 'marker 2' if new_x == 6 && new_y == 0
    return false if obstructed?(new_x, new_y)
    $stderr.puts 'marker 3' if new_x == 6 && new_y == 0

    piece_at_destination = game.pieces.find_by(x_pos: new_x, y_pos: new_y)
    return false if piece_at_destination && piece_at_destination.color == color

    $stderr.puts 'marker 4' if new_x == 6 && new_y == 0

    x_diff = (x_pos - new_x).abs
    y_diff = (y_pos - new_y).abs
    if (x_diff <= 1) && (y_diff <= 1)
      $stderr.puts 'marker 5-a' if new_x == 6 && new_y == 0
      return true
    elsif new_x == 2 && new_y == 0 && !moved && !in_check?
      $stderr.puts 'marker 5-b' if new_x == 6 && new_y == 0
      return true
    elsif new_x == 2 && new_y == 0 && !moved && !in_check?
      $stderr.puts 'marker 5-c' if new_x == 6 && new_y == 0
      return true
    elsif new_x == 6 && new_y == 0 && !moved && !in_check?
      $stderr.puts 'marker 5-d' if new_x == 6 && new_y == 0
      return true
    elsif new_x == 6 && new_y == 7 && !moved && !in_check?
      $stderr.puts 'marker 5-e' if new_x == 6 && new_y == 0
      return true
    else
      return false
    end
  end

  def move_to!(new_x, new_y)

    return false if !valid_move?(new_x, new_y)

    if new_x == 6 && new_y == 0 && moved? == false
      castle!(7, 0) if castle?(7, 0)
    elsif new_x == 2 && new_y == 0 && moved? == false
      castle!(0, 0) if castle?(0, 0)
    elsif new_x == 6 && new_y == 7 && moved? == false
      castle!(7, 7) if castle?(7, 7)
    elsif new_x == 2 && new_y == 7 && moved? == false
      castle!(0, 7) if castle?(0, 7)
    end
     self.update_attributes({:x_pos => new_x, :y_pos => new_y, :moved => true})
     return true
  end


  def castle!(rook_x_pos, rook_y_pos)
    rook = game.pieces.find_by(x_pos: rook_x_pos, y_pos: rook_y_pos)
    raise 'Invalid move' unless castle?(rook_x_pos, rook_y_pos)
    if rook_x_pos == 7
      update_attributes(x_pos: x_pos + 2)
      rook.update_attributes(x_pos: rook_x_pos - 2)
    elsif rook_x_pos.zero?
      update_attributes(x_pos: x_pos - 2)
      rook.update_attributes(x_pos: rook_x_pos + 3)
    end
  end


  def castle?(rook_x_pos, rook_y_pos)
    return false if moved || in_check?
    rook = game.pieces.find_by(x_pos: rook_x_pos, y_pos: rook_y_pos, type: 'Rook')
    return false if obstructed?(rook_x_pos, rook_y_pos)
    return false if rook.nil? || rook.moved
    return false if rook_x_pos != 7 && rook_x_pos != 0
    if rook_x_pos == 7
      new_x_pos = x_pos
      while new_x_pos < rook_x_pos - 1
        new_x_pos += 1
        return false if game.move_puts_self_in_check?(self, new_x_pos, y_pos)
      end
    end
    if rook_x_pos.zero?
      new_x_pos = x_pos
      while new_x_pos > rook_x_pos + 2
        new_x_post -= 1
        return false if game.move_puts_self_in_check?(self, new_x_pos, y_pos)
      end
    end
    true
  end

    def in_check?
      opposing_color = (color == 0 ? 1 : 0)

      cur_game = Game.find_by(id: game_id)
      opposing_pieces = cur_game.pieces.where(color: opposing_color).where.not(x_pos: nil).where.not(y_pos:nil)

      opposing_pieces.each do |p|
        return true if p.valid_move?(x_pos, y_pos)
      end

      return false
    end

  def obstructed?(x_destination, y_destination)
   game = Game.find(self.game_id)
   x_location = self.x_pos
   y_location = self.y_pos
   #check for vertical obstructions
   if x_location == x_destination && y_location != y_destination
     y_location > y_destination ? incrementer = -1 : incrementer = 1
     y_position = y_location + incrementer
     while y_position != y_destination
       if game.pieces.where(x_pos: x_location, y_pos: y_position).any?
         return true
       end
       y_position += incrementer
     end
     return false
   #check for horizontal obstructions
   elsif y_location == y_destination && x_location != x_destination
     x_location > x_destination ? incrementer = -1 : incrementer = 1
     x_position = x_location + incrementer
     while x_position != x_destination
       if game.pieces.where(x_pos: x_position, y_pos: y_location).any?
         return true
       end
       x_position += incrementer
     end
     return false
   #check for diagnol obstructions
  elif x_location == x_destination && y_location == y_destination
     x_location > x_destination ? x_incrementer = -1 : x_incrementer = 1
     y_location > y_destination ? y_incrementer = -1 : y_incrementer = 1
     x_position = x_location + x_incrementer
     y_position = y_location + y_incrementer
     while x_position != x_destination && y_position != y_destination
       if game.pieces.where(x_pos: x_position, y_pos: y_position).any?
         return true
       end
       x_position += x_incrementer
       y_position += y_incrementer
     end
     return false
   end
  end

end
