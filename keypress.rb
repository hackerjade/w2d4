require 'io/console'

# Reads keypresses from the user including 2 and 3 escape character sequences.
def read_char
  STDIN.echo = false
  STDIN.raw!

  input = STDIN.getc.chr
  if input == "\e" then
    input << STDIN.read_nonblock(3) rescue nil
    input << STDIN.read_nonblock(2) rescue nil
  end
ensure
  STDIN.echo = true
  STDIN.cooked!

  return input
end

# oringal case statement from:
# http://www.alecjacobson.com/weblog/?p=75
def show_single_key
  c = read_char

  case c
  when "\\"
    return :drop_off
    # puts "BACKSLASH"
  when "'"
    return :drop
    # puts "APOSTROPHE"
  when "\r"
    return :pick_up
    # puts "RETURN"
  when "\e"
    return "\e"
  when "\e[A"
    return [-1, 0]
    # puts "UP ARROW"
  when "\e[B"
    return [1, 0]
    # puts "DOWN ARROW"
  when "\e[C"
    return [0, 1]
    # puts "RIGHT ARROW"
  when "\e[D"
    return [0, -1]
    # puts "LEFT ARROW"
  when "\u0003"
    puts "       goodbye!"
    exit 0
  # when /^.$/
  #   puts "SINGLE CHAR HIT: #{c.inspect}"
  end
end

# show_single_key while(true)
