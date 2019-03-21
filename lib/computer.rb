require './lib/board'

class Computer
  attr_reader :board, :ships

  def initialize(name, size = 10)
    @board = Board.new(name, size)
    @ships = []
  end

  def place(ship)
    valid = :none

    while valid != :success do
      coord = @board.cells.keys.sample
      direction = rand(2)
      # 0 = right (horizontal), 1 = down (vertical)
      #require 'pry'; binding.pry
      valid = place_if_valid(ship, coord, direction)
    end
    @ships << ship
  end

  def place_if_valid(ship, coord, direction)
    if @board.valid_coordinate?(coord.to_s)
      if direction == 0 # right
        return @board.place(ship, coord, true)
      else direction == 1 # down
        return @board.place(ship, coord)
      end
    end
    return :none
  end

  def find_valid_target
    @valid_target = false
    target = nil

    while !@valid_target do
      target = @board.cells.keys.sample
      # TO DO ^ iter 4 smart computer

      if @board.valid_coordinate?(target.to_s)
        if !@board[target.to_sym].fired_upon?
          @board[target.to_sym].fire_upon; @valid_target = true
        end
      end
    end
    target
  end

  def turn(opp)
    target = find_valid_target

    puts "Computer fired on #{target}."

    # TO DO: abstract into a helper method
    if opp.board[target.to_sym].empty?
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
