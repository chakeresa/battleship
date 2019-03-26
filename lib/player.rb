require './lib/board'
require './lib/turn_result'

class Player
  attr_reader :name, :board, :ships

  include TurnResult

  def initialize(name, size = 10)
    @name = name
    @board = Board.new(name, size)
    @ships = []
  end

  def get_starting_coord(ship)
    valid = false
    while !valid
      puts "Placing: " + ship.name + ", with Length of " + ship.length.to_s
      puts "Pick a starting coordinate."
      print ">> "; coord = gets.chomp.upcase
      return :quit if coord == '!'

      if @board.cells.keys.include?(coord.to_sym)
        valid = true
        return coord
      else
        puts "Invalid starting coordinate."
        valid = false
      end
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
        coord = (coord[0].ord - (ship.length - 1)).chr + coord[1]; valid = true
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

  def turn(opp)
    valid = false
    while !valid do
      puts "Pick a target."
      print ">> "; target = gets.chomp.upcase
      return :quit if target == '!'
      target = target.to_sym
      valid = valid_target?(opp, target)
    end

    return turn_result(opp, target)
  end
end
