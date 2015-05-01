class Player
  attr_reader :name, :color

  def initialize(name, color)
    @name = name
    @color = color
  end

  def inspect
      {:name => @name, :color => @color}.inspect
  end
end

class HumanPlayer < Player
  def get_input
    show_single_key
  end
end

class ComputerPlayer < Player

end

if __FILE__ == $PROGRAM_NAME
  player = HumanPlayer.new("Jade", :red)
  player.get_input
end
