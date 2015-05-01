require 'byebug'
require 'colorize'
require 'io/console'
require_relative 'board'
require_relative 'errors'
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
    until game_over?
      begin
        move_piece
      rescue OutOfTurnError => e
        puts e.message
        retry
      end
      @current_player = switch_players
      display_board
    end
  end

  private
  def display_board
    system "clear"
    puts @board.display
    puts "   current_player: #{@current_player.color}"
  end

  def game_over?

  end

  def greet
    system "clear"
    puts @board.display
    puts "  Let the game begin!"
    puts "   current_player: #{@current_player.color}"
  end

  def make_players
    [HumanPlayer.new(player1, :red), HumanPlayer.new(player2, :black)]
  end

  def move_piece
    begin
      start_pos, end_pos = parse_input(@current_player)
      if @board[start_pos].nil?
        raise OutOfTurnError.new "There's no piece there!"
      elsif @board[start_pos].color != @current_player.color
        raise OutOfTurnError.new "That's not your piece!"
      end
      @board.move(start_pos, end_pos)
    rescue OutOfTurnError => e
      puts e.message
      retry
    rescue InvalidKeyError => e
      puts e.message
      retry
    rescue InvalidMoveError => e
      puts e.message
      retry
    rescue RuntimeError => e
      puts e.message
      retry
    end
  end

  def parse_input(player)
    start_pos, input, end_pos = nil, nil, []
    until start_pos && input == :drop
      input = player.get_input
      raise InvalidKeyError.new "Invalid key!" if !valid_key?(input)
      if input == :drop
        break
      elsif input == :pick_up
        start_pos = @board.cursor
      elsif input == :drop_off && start_pos
        end_pos << @board.cursor
      elsif input != :drop_off
        @board.move_cursor(input)
        display_board
      end
    end

    [start_pos, end_pos]
  end

  def switch_players
    @current_player == @players[0] ? @players[1] : @players[0]
  end

  def valid_key?(input)
    move_dirs = [[-1, 0], [1, 0], [0, 1], [0, -1]]
    input == :pick_up || input == :drop_off || input == :drop ||
    move_dirs.any? { |dir| dir == input}
  end
end

if __FILE__ == $PROGRAM_NAME
  game = Game.new("Jade", "Loser")
  game.play
end
