class InvalidMoveError < StandardError
end

class OutOfTurnError < TypeError
end

class InvalidKeyError < KeyError
end

# if @board[start_pos].nil?
#   raise OutOfTurnError.new "There's no piece there!"
# elsif @board[start_pos].color != @current_player.color
#   raise OutOfTurnError.new "That's not your piece!"
