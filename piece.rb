class Piece
  attr_reader :color, :promotion_row
  attr_accessor :pos, :promoted

  def initialize(color, pos, promoted = false)
    @color = color
    @pos = pos
    @promoted = promoted
    @promotion_row = find_promotion_row
  end

  def find_promotion_row
    @pos[0] == 7 ? 0 : 7
  end

  def perform_slide(position)
    delta = [position[0] - @pos[0], position[1] - @pos[1]]
    return false if !move_diffs.include?(delta)
    @pos = position
    # maybe_promote
    return true
  end

  def maybe_promote
    # @promoted == true if @pos[1] == #opposite side of board
  end

  def perform_jump
    #remove the other piece we jumped over FROM BOARD
  end

  def is_valid?

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
  red = Piece.new(:red, [7,1])
  black = Piece.new(:black, [0,1])
  p [red.color, red.pos]
  p [black.color, black.pos]
  red.perform_slide([6,0])
  black.perform_slide([1,0])
  p [red.color, red.pos]
  p [black.color, black.pos]
  p red.promotion_row
  p black.promotion_row
end
