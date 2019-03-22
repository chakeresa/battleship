require './lib/board'

class Player
  attr_reader :board, :ships

  def initialize(name, size = 10)
    @board = Board.new(name, size)
    @ships = []
  end

  def place(ship)
    valid = :none


    while valid != :success do
      get_starting_coord(ship)

      puts "Pick a direction -- enter right (r) or down (d)."
      print ">> "; direction = gets.chomp.downcase
      return :quit if direction == '!'

      if direction != "right" && direction != "r" && direction != "down" && direction != "d"
        puts "Invalid direction input."
        return valid = :invalid_dir_inp
      else
        horizontal = direction == "right" || direction == "r"
      end

      valid = @board.place(ship, coord, horizontal)
      @ships << ship if valid == :success

      puts "Out of bounds!" if valid == :oob
      puts "Overlap!" if valid == :overlap
    end
  end

  def get_starting_coord(ship)
    puts "Placing: " + ship.name + ", with Length of " + ship.length.to_s
    puts "Pick a starting coordinate (top left part of the ship)."
    print ">> "; coord = gets.chomp
    return :quit if coord == '!'

    if @board.cells.keys.include?(coord.to_sym) == false
      puts "Invalid starting coordinate."
      return valid = :invalid_start_coord
    end
  end

  def turn(opp)
    valid = false
    while !valid do
      puts "Pick a target."
      print ">> "; input = gets.chomp
      return :quit if input == '!'

      if opp.board.valid_coordinate?(input)
        if !opp.board[input.to_sym].fired_upon?
          opp.board[input.to_sym].fire_upon; valid = true
        else
          puts "That's already been fired upon!"
        end

      else
        puts "Invalid coordinate."
      end
    end

    if opp.board[input.to_sym].empty?
      puts " --- MISS!"
      return :none
    else
      puts " --- HIT!"

      # TO DO: message when sunk
      if opp.ships.all? {|ship| ship.sunk?}
        return :win
      else
        return :none
      end
    end
  end
end
