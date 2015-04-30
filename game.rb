require_relative 'piece'
require_relative 'board'
require_relative 'player'
require 'colorize'
require 'byebug'
require 'io/console'

class Game
  attr_reader :player1, :player2

  def initialize(player1, player2)
    @board = Board.new
    @player1 = HumanPlayer.new(player1, :red)
    @player2 = HumanPlayer.new(player2, :black)
  end

  def play
    puts @board.display
    begin
      start_pos, end_pos = parse_input(@player1)
    rescue RuntimeError => e
      puts "Invalid key!"
      retry
    end
      @board.move(start_pos, end_pos)
      system "clear"
      puts @board.display
  end

  def parse_input(player)
    start_pos, end_pos = nil, nil
    until start_pos && end_pos
      input = player.get_input
      raise RuntimeError.new "Invalid!" if !valid_key?(input)
      if input == :pick_up
        start_pos = @board.cursor
      elsif input == :drop_off && start_pos
        end_pos = @board.cursor
      else
        @board.move_cursor(input)
        system "clear"
        puts @board.display
      end
    end

    [start_pos, end_pos]
  end

  def valid_key?(input)
    move_dirs = [[-1, 0], [1, 0], [0, 1], [0, -1]]
    input == :pick_up || input == :drop_off ||
    move_dirs.any? { |dir| dir == input}
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new("Jade", "Loser")
  game.play
end
