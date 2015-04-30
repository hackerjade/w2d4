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

  def inspect
    {:color => @color}.inspect
  end

  def perform_jump(position)
    delta = [(position[0] - @pos[0]) / 2, (position[1] - @pos[1]) / 2]
    capture = @pos[0] + delta[0], @pos[1] + delta[1]

    if !move_diffs.include?(delta) || @board.empty?(capture)
      raise RuntimeError.new "Invalid move!"
    elsif @board.own_piece?(capture, @color)
      raise RuntimeError.new "Can't capture your own piece!"
    end

    @board[@pos], @pos, @board[position] = nil, position, self
    @board[capture] = nil
    maybe_promote

    true
  end

  def perform_move!(move_sequence)
    if move_sequence.length == 1
      perform_slide(move_sequence[0]) || perform_jump(move_sequence[0])
    else
      move_sequence.each do |move|
        perform_jump(move)

        # @board[@pos], @pos, @board[move] = nil, move, self
        # @board[capture] = nil
        # maybe_promote
        # @pos = move
      end
  end

  def perform_slide(position)
    delta = [position[0] - @pos[0], position[1] - @pos[1]]
    false if !move_diffs.include?(delta)
    @board[@pos], @pos, @board[position] = nil, position, self
    maybe_promote

    true
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
