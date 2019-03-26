require './lib/board'
require './lib/turn_result'

class Computer
  attr_reader :name, :board, :ships

  include TurnResult

  def initialize(name, size = 10)
    @name = name
    @board = Board.new(name, size)
    @ships = []
    @state = :random
    @last = nil
    @opp = nil
  end
  #States are:
  # :random = random firing pattern
  # :inithit = We've made our first hit
  # :direct = We know it's direction and are filling out the board

  def place(ship, coord_and_dir = rand_coord_and_direc)
    valid = :none

    coord, horizontal = coord_and_dir # allows for non-random placement for testing

    while valid != :success do
      valid = @board.place(ship, coord, horizontal)

      coord, horizontal = rand_coord_and_direc
    end

    @ships << ship
    return valid
  end

  def state_Random
    target = find_valid_target(@opp)
    puts "#{@name.lstrip.rstrip.capitalize} fired on #{target}."
    result = turn_result(@opp, target)
    @last = target
    if result == :hit
      @state = :inithit
    end
    return result
  end

  def state_InitialHit
    valid = false
    tried = [false, false, false, false]
    direction = nil
    while !valid
      direction = rand(0..3)
      case direction
      when 0 #up
        target = ((@last[0].ord - 1).chr + @last[1]).to_sym
        tried[0] = true
      when 1 #left
        target = (@last[0] + (@last[1].to_i - 1).to_s).to_sym
        tried[1] = true
      when 2 #down
        target = ((@last[0].ord + 1).chr + @last[1]).to_sym
        tried[2]= true
      when 3 #right
        target = (@last[0] + (@last[1].to_i + 1).to_s).to_sym
        tried[3] = true
      end
      valid = true if valid_target?(@opp, target)
      break if tried == [true, true, true, true]
    end
    if valid
      puts "#{@name.lstrip.rstrip.capitalize} fired on #{target}."
      result = turn_result(@opp, target)
      if result == :hit
        @state = [0, 2].include? direction ? :vertical : :horizontal
      end
      return result
    else #Somehow there are no options. Give it a random go
      @state = :random
      return state_Random
    end
  end

  def state_Directed_Horizontal

  end

  def state_Directed_Vertical

  end

  def rand_coord_and_direc
    coord = @board.cells.keys.sample
    num = rand(2)
    # 0 = right (horizontal), 1 = down (vertical)
    horizontal = num == 0
    return coord, horizontal
  end

  def find_valid_target(opp, target = random_target(opp))
    valid = false

    while !valid do
      valid = valid_target?(opp, target)
      target = random_target(opp) if !valid
      # TO DO ^ iter 4 smart computer
    end
    return target
  end

  def random_target(opp)
    opp.board.cells.keys.sample
  end

  def turn(opp)
    case @state
    when :random
      result = state_Random
    when :inithit
      result = state_InitialHit
    when :horizontal

    when :vertical

    else

    end

    return result
  end
end
