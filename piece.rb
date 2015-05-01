class Piece
  attr_reader :color
  attr_accessor :pos, :promoted

  def initialize(color, pos, board, promoted = false)
    @color = color
    @pos = pos
    @board = board
    @promoted = promoted
  end

  def display
    @promoted ? symbol = " \u265A " : symbol = " \u2688 "
    symbol.colorize(@color)
  end

  def dup(board)
    dup_piece = Piece.new(@color, @pos, board, @promoted)
  end

  def inspect
    {:color => @color}.inspect
  end

  def perform_jump(position)
    delta = [(position[0] - @pos[0]) / 2, (position[1] - @pos[1]) / 2]
    capture = @pos[0] + delta[0], @pos[1] + delta[1]

    if !move_diffs.include?(delta) || @board.empty?(capture)
      byebug
      raise RuntimeError.new "Invalid move!"
      # return false
    elsif @board.own_piece?(capture, @color)
      raise RuntimeError.new "Can't capture your own piece!"
    end

    @board[@pos], @pos, @board[position] = nil, position, self
    @board[capture] = nil
    maybe_promote

    true
  end

  def perform_move(move_seqs)
    begin
      if valid_move_seq?(move_seqs)
        perform_move!(move_seqs, @board)
      end
    end
  end

  def perform_move!(move_sequence, board)
    if move_sequence.length == 1
      begin
        perform_slide(move_sequence[0]) || perform_jump(move_sequence[0])
      end
    else
      move_sequence.each do |move|
        delta = [(move[0] - @pos[0]) / 2, (move[1] - @pos[1]) / 2]
        capture = @pos[0] + delta[0], @pos[1] + delta[1]
        if !move_diffs.include?(delta) || board.empty?(capture)
          raise InvalidMoveError.new "Invalid jumps!"
        elsif board.own_piece?(capture, @color)
          raise InvalidMoveError.new "Can't capture your own piece!"
        end

        board[@pos], @pos, board[move] = nil, move, self
        board[capture] = nil
        maybe_promote

        true
      end
    end
  end

  def perform_slide(position)
    delta = [position[0] - @pos[0], position[1] - @pos[1]]
    return false if !move_diffs.include?(delta)
    @board[@pos], @pos, @board[position] = nil, position, self
    maybe_promote

    true
  end

  def valid_move_seq?(sequences)
    dup_board = @board.dup

    begin
      dup_board[@pos.dup].perform_move!(sequences, dup_board)
    rescue RuntimeError => e
      raise e
      false
    else
      true
    end
  end

  private
  def promotion_row
    @color == :red ? 0 : 7
  end

  def maybe_promote
    @promoted = true if @pos[0] == promotion_row
  end

  def move_diffs
    if color == :red && promoted == false
      directions = [
        [-1, -1],
        [-1, 1]
      ]
    elsif color == :black && promoted == false
      directions = [
        [1, -1],
        [1, 1]
      ]
    elsif promoted == true
      directions = [
                    [-1, -1],
                    [-1, 1],
                    [1, -1],
                    [1, 1]
                    ]
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  red = Piece.new(:red, [7,7], board)
  black = Piece.new(:black, [0,1], board)
end
