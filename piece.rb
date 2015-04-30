class Piece
  attr_reader :color
  attr_accessor :pos, :promoted

  def initialize(color, pos, promoted = false)
    @color = color
    @pos = pos
    @promoted = promoted
  end
end
