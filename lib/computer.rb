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
      num = rand(2)
      # 0 = right (horizontal), 1 = down (vertical)
      horizontal = num == 0

      valid = @board.place(ship, coord, horizontal)
      # TO DO: ^ similar simplification to Player
      @ships << ship
    end
    valid
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
