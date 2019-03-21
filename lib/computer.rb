require './lib/board'

class Computer
  attr_reader :board

  def initialize(size = 10)
    @board = Board.new(size)
  end

  def place(ship)
    @valid_place = :none

    while @valid_place != :success do
      coord = @board[@board.cells.keys.sample]
      direction = rand(2)
      # 0 = right (horizontal), 1 = down (vertical)

      place_if_valid(ship, coord, direction)
    end

    @valid_place = :none
  end

  def place_if_valid(ship, coord, direction)
    if @board.valid_coordinate?(coord)
      if direction == 0 # right
        @valid_place = @board.place(ship, coord, true)
      else direction == 1 # down
        @valid_place = @board.place(ship, coord)
      end
    end
  end

  def turn
    @valid_target = false
    target = nil

    while !@valid_target do
      target = @board[@board.cells.keys.sample]
      # TO DO ^ iter 4 smart computer

      if @board.valid_coordinate?(target)
        if !@board[target.to_sym].fired_upon?
          @board[target.to_sym].fire_upon; @valid_target = true
        end
      end
    end

    puts "Computer fired on #{target}."

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
