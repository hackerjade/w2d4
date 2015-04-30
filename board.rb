require_relative 'piece'
require 'colorize'
require 'byebug'
require 'io/console'

class Board
  attr_reader :cursor

  def initialize(game_beginning = true)
    @board = Array.new(8) {Array.new(8)}
    @cursor = [5, 3]
    set_up_board if game_beginning
  end

  def [](pos)
    row, col = pos
    @board[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @board[row][col] = value
  end

  def move(start_pos, end_pos)
    begin
      row, col = start_pos
      @board[row][col].perform_slide(end_pos)
    rescue RuntimeError => e
      begin
        @board[row][col].perform_jump(end_pos)
      rescue RuntimeError => e
        puts "Can't capture your own piece!"
      end
    end
  end

  def empty?(pos)
    row, col= pos
    @board[row][col].nil?
  end

  def own_piece?(pos, compared_color)
    row, col = pos
    @board[row][col].color == compared_color
  end

  def on_board?(pos)
    pos.all? { |pos| pos.between?(0, 7) }
  end

  def display
    (0..7).map do |row|
      (0..7).map do |col|
        if @board[row][col].nil?
          "   ".colorize(:background => color_board(row, col))
        else
          @board[row][col].display.colorize(:background => color_board(row, col))
        end
      end.join("")
    end.join("\n")
  end

  def color_board(row, col)
    if @cursor == [row, col]
      :yellow
    elsif row.even? && col.even? || row.odd? && col.odd?
      :cyan
    else
      :light_cyan
    end
  end

  def move_cursor(direction)
    new_x = @cursor[0] + direction[0]
    new_y = @cursor[1] + direction[1]
    @cursor = [new_x, new_y] if on_board?([new_x, new_y])
  end

  private
  def set_up_board
    #set up black pieces
    (0..2).each do |row|
      alternate_checkers(row, :black)
    end

    #set up red pieces
    (5..7).each do |row|
      alternate_checkers(row, :red)
    end
  end

  def alternate_checkers(row, color)
    (0..7).each do |col|
      if row.odd? && col.odd? || row.even? && col.even?
        @board[row][col] = Piece.new(color, [row, col], self)
      end
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  board = Board.new
  board.move([5,5], [4,4])
end
