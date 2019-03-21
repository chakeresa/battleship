require './lib/board'

class Computer
  attr_reader :board

  def initialize(size = 10)
    @board = Board.new(size)
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
    end
    valid
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

  def turn
    target = find_valid_target

    puts "Computer fired on #{target}."

    # TO DO: abstract into a helper method
    if @board[target.to_sym].empty?
      puts " --- MISS!"
      return :none
    else
      puts " --- HIT!"
      # TO DO: message when sunk
      if @ships.all {|ship| ship.sunk?}
        return :win
      else
        return :none
      end
    end
  end
end
