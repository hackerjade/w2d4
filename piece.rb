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
    maybe_promote
    return true
  end

  def maybe_promote
    @promoted = true if @pos[0] == @promotion_row
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
  red = Piece.new(:red, [7,7])
  black = Piece.new(:black, [0,1])
  red.perform_slide([6,6])
  red.perform_slide([5,5])
  red.perform_slide([4,4])
  red.perform_slide([3,3])
  red.perform_slide([2,2])
  red.perform_slide([1,1])
  red.perform_slide([0,0])
end
