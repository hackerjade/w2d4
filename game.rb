require 'byebug'
require 'colorize'
require 'io/console'
require_relative 'board'
require_relative 'keypress'
require_relative 'piece'
require_relative 'player'

class Game
  attr_reader :player1, :player2

  def initialize(player1, player2)
    @board = Board.new
    @players = make_players
    @current_player = @players[0]
  end

  def play
    greet
    start_pos = [0, 0]
    until game_over?(start_pos)
      begin
        move_piece
      rescue TypeError => e
        puts e.message
        retry
      end
      display_board
      @current_player = switch_players
    end
  end

  private
  def display_board
    system "clear"
    puts @board.display
  end

  def game_over?(pos)
    pos == [3, 7]
  end

  def greet
    puts "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n  Let the game begin!"
    puts @board.display
  end

  def make_players
    [HumanPlayer.new(player1, :red), HumanPlayer.new(player2, :black)]
  end

  def move_piece
    begin
      start_pos, end_pos = parse_input(@current_player)
      if @board[start_pos].nil?
        raise TypeError.new "There's no piece there!"
      elsif @board[start_pos].color != @current_player.color
        raise TypeError.new "That's not your piece!"
      end
      @board.move(start_pos, end_pos)
    rescue KeyError => e
      puts e.message
      retry
    rescue RuntimeError => e
      puts e.message
      retry
    end
  end

  def parse_input(player)
    start_pos, end_pos = nil, nil
    until start_pos && end_pos
      input = player.get_input
      raise RuntimeError.new "Invalid key!" if !valid_key?(input)
      if input == :pick_up
        start_pos = @board.cursor
      elsif input == :drop_off && start_pos
        end_pos = @board.cursor
      elsif input != :drop_off
        @board.move_cursor(input)
        system "clear"
        puts @board.display
      end
    end

    [start_pos, end_pos]
  end

  def switch_players
    @current_player == @players[0] ? @players[1] : @players[0]
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
