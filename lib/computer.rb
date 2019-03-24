require './lib/board'

class Computer
  attr_reader :name, :board, :ships

  def initialize(name, size = 10)
    @name = name
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

      coord, horizontal = rand_coord_and_direc
    end

    @ships << ship
    valid
  end

  def rand_coord_and_direc
    coord = @board.cells.keys.sample
    num = rand(2)
    # 0 = right (horizontal), 1 = down (vertical)
    horizontal = num == 0
    return coord, horizontal
  end

  def find_valid_target(opp, target = random_target(opp))
    @valid_target = false

    while !@valid_target do
      if opp.board.valid_coordinate?(target.to_s)
        if !opp.board[target.to_sym].fired_upon?
          opp.board[target.to_sym].fire_upon; @valid_target = true
        else
          target = random_target(opp)
          # TO DO ^ iter 4 smart computer
        end
      end

    end
    target
  end

  def random_target(opp)
    opp.board.cells.keys.sample
  end

  def turn(opp)
    target = find_valid_target(opp).to_sym

    puts "#{@name.lstrip.rstrip} fired on #{target}."

    # TO DO: abstract into a helper method
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
