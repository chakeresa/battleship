require './lib/board'

class Computer
  attr_reader :board

  def initialize(size = 10)
    @board = Board.new(size)
  end

  def place(ship)
    valid = :none

    while valid != :success do
      coord = @board[@board.cells.keys.sample]
      direction = rand(2)
      # 0 = right (horizontal), 1 = down (vertical)

      if @board.valid_coordinate?(coord)
        if direction == 0 # right
          valid = @board.place(ship, coord, true)
        else direction == 1 # down
          valid = @board.place(ship, coord)
        end
      end
    end
  end

  def turn

  end
end
