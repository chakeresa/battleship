require './lib/board'

class Player
  attr_reader :name, :board, :ships

  def initialize(name, size = 10)
    @name = name
    @board = Board.new(name, size)
    @ships = []
  end

  def get_starting_coord(ship)
    puts "Placing: " + ship.name + ", with Length of " + ship.length.to_s
    puts "Pick a starting coordinate."
    print ">> "; coord = gets.chomp
    return :quit if coord == '!'

    if @board.cells.keys.include?(coord.to_sym)
      return coord
    else
      puts "Invalid starting coordinate."
      return valid = :invalid_start_coord
    end
  end

  def get_dir_input(coord, ship)
    valid = false
    while !valid
        puts "Pick a direction (left, right, up, down OR l,r,u,d)."
        print ">> "; direction = gets.chomp.downcase
        return :quit if direction == '!'

        direction_return = false
        if direction.match?(/^l$|^left$/)
            coord = coord[0] + (coord[1].to_i - (ship.length - 1)).to_s
            direction_return = true; valid = true
        elsif direction.match?(/^r$|^right$/)
            direction_return = true; valid = true
        elsif direction.match?(/^u$|^up$/)
            coord = (coosrd[0].ord - (ship.length - 1)).chr + coord[1]; valid = true
        elsif direction.match?(/^d$|^down$/)
            valid = true
        else
            puts "Invalid direction input."
        end
    end

    return direction_return, coord
  end

  def place(ship)
    valid = :none

    while valid != :success do
      coord_input = get_starting_coord(ship)
      coord_input == :quit ? (return :quit) : coord = coord_input
      dir, coord = get_dir_input(coord, ship)
      dir == :quit ? (return :quit) : horizontal = dir

      valid = @board.place(ship, coord, horizontal)
      @ships << ship if valid == :success

      puts "Out of bounds!" if valid == :oob
      puts "Overlap!" if valid == :overlap
    end
  end

  def turn(opp) # TO DO: refactor
    valid = false
    while !valid do
      puts "Pick a target."
      print ">> "; target = gets.chomp
      return :quit if target == '!'

      target = target.to_sym
      if opp.board.valid_coordinate?(target.to_s)
        if !opp.board[target].fired_upon?
          opp.board[target].fire_upon; valid = true
        else
          puts "That's already been fired upon!"
        end
      else
        puts "Invalid coordinate."
      end
    end

    if opp.board[target].empty?
      puts " --- MISS!"
      return :none
    else
      puts " --- HIT!"

      if opp.board[target].ship.sunk?
        puts "#{@name.lstrip.rstrip} sunk #{opp.name.lstrip.rstrip}'s #{opp.board[target].ship.name}!!!"
      end

      if opp.ships.all? {|ship| ship.sunk?}
        return :win
      else
        return :none
      end
    end
  end
end
