require './lib/board'

class Computer
  attr_reader :board, :ships

  def initialize(name, size = 10)
    @board = Board.new(name, size)
    @ships = []
    # TO DO: ^ why needed?
  end

  def place(ship, coord_and_dir = rand_coord_and_direc)
    valid = :none

    coord, horizontal = coord_and_dir # allows for non-random placement for testing
    i = 0

    while valid != :success do
      valid = @board.place(ship, coord, horizontal)
      # TO DO: ^ similar simplification to Player
      @ships << ship # TO DO: adds ships every time it tries to place - fix

      coord, horizontal = rand_coord_and_direc
    end
    valid
  end

  def rand_coord_and_direc
    coord = @board.cells.keys.sample
    num = rand(2)
    # 0 = right (horizontal), 1 = down (vertical)
    horizontal = num == 0
    return coord, horizontal
  end

  def find_valid_target(opp)
    @valid_target = false
    target = nil

    while !@valid_target do
      target = opp.board.cells.keys.sample
      # TO DO ^ iter 4 smart computer

      if opp.board.valid_coordinate?(target.to_s)
        if !opp.board[target.to_sym].fired_upon?
          opp.board[target.to_sym].fire_upon; @valid_target = true
        end
      end
    end
    target
  end

  def turn(opp)
    target = find_valid_target(opp)

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
