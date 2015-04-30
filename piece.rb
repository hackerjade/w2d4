class Piece
  attr_reader :color
  attr_accessor :pos, :promoted

  def initialize(color, pos, promoted = false)
    @color = color
    @pos = pos
    @promoted = promoted
  end

  def perform_slide
    return true if is_valid?()
    maybe_promote
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
    #returns all directions a piece could move in
  end
end
