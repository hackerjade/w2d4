require_relative 'piece'
require 'colorize'
require 'byebug'

class Board
  def initialize(game_beginning = true)
    @board = Array.new(8) {Array.new(8)}
    set_up_board if game_beginning
  end

  def [](row, col)
    @board[row][col]
  end

  def []=(row, col, value)
    @board[row][col] = value
  end

  def move(start_pos, end_pos)
    begin
      # byebug
      row, col = start_pos
      @board[row][col].perform_slide(end_pos)
    rescue RuntimeError => e
      puts "Plese choose a valid move."
    end
  end

  def empty?(row, col)
    @board[row][col].nil?
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
    if row.even? && col.even? || row.odd? && col.odd?
      :white
    else
      :black
    end
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
      if color == :black
        if row.odd? && col.even? || row.even? && col.odd?
          @board[row][col] = Piece.new(color, [row, col], self)
        end
      elsif color == :red
        if row.odd? && col.odd? || row.even? && col.even?
          @board[row][col] = Piece.new(color, [row, col], self)
        end
      end
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  board = Board.new
  board.move([5,5], [4,4])
  # p board[0,0]
  # p board[0,1] = nil
  # puts board.display
end
