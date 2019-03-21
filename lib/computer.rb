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
    valid = false
    target = nil
    while !valid do
      target = @board[@board.cells.keys.sample]
      # TO DO ^ iter 4 smart computer

      if @board.valid_coordinate?(target)
        if !@board[target.to_sym].fired_upon?
          @board[target.to_sym].fire_upon; valid = true
        end
      end
    end

    puts "Computer fired on #{target}."

    if @board[target.to_sym].empty?
      puts " --- MISS!"
      return :none
    else
      puts " --- HIT!"
      if @ships.all {|ship| ship.sunk?}
        return :win
      else
        return :none
      end
    end
  end
end
