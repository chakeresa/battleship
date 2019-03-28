require './lib/board'
require './lib/turn_result'
require './lib/rec'

class Computer
  extend TailRec
  include TurnResult

  attr_reader :name, :board, :ships
  def initialize(name, size = 10)
    @name = name
    @board = Board.new(name, size)
    @ships = []
    @state = :random
    @last = nil
    @opp = nil
    @initHit = nil
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

  def fetch_adjacent(coord, direction)
    case direction
    when :up
      return ((coord[0].ord - 1).chr + coord[1..-1]).to_sym
    when :right
      return (coord[0] + (coord[1..-1].to_i + 1).to_s).to_sym
    when :down
      return ((coord[0].ord + 1).chr + coord[1..-1]).to_sym
    when :left
      return (coord[0] + (coord[1..-1].to_i - 1).to_s).to_sym
    end
  end

  def state_Random
    target = find_likely_target
    result = turn_result(@opp, target)
    @last = target
    if result == :hit
      @state = :inithit
    end
    return result
  end

  def find_likely_target
  #require 'pry'; binding.pry
    lengths = @opp.ships.map {|x| x.sunk? ? nil : x.length}
    if lengths.compact
      lengths.compact!
    end
    lengths.sort!
    until lengths == []
      weights = {}
      @opp.board.cells.keys.each do |key|
        if !@opp.board[key].fired_upon?
          weights[key] = iterate_possibilities(key, false, lengths.last - 1, 0, 0) +\
                                      iterate_possibilities(key, true, lengths.last - 1, 0, 0)
        else
          weights[key] = 0
        end
      end
      bestValue = weights.max_by{|k, v| v}[1]
      bestChoice = weights.keep_if{|k,v| v == bestValue}.keys.sample
      return bestChoice if weights[bestChoice] != 0
      lengths.pop
    end
      return find_valid_target(@opp)
  end

  rec def iterate_possibilities(key, horizontal, forward, reverse, out)
    if forward == 0
      if horizontal
        out += 1 if find_empty(key, :left, reverse, 0)
      else
        out += 1 if find_empty(key, :up, reverse, 0)
      end
      return out
    end
    if horizontal
      out += 1 if find_empty(key, :right, forward, 0) && find_empty(key, :left, reverse, 0)
    else
      out += 1 if find_empty(key, :down, forward, 0) && find_empty(key, :up, reverse, 0)
    end
    iterate_possibilities(key, horizontal, forward - 1, reverse + 1, out)
  end

  rec def find_empty(coord, direction, length, i)
    if i == length
      return true
    end
    target = fetch_adjacent(coord, direction)
    if !@opp.board.valid_coordinate?(target.to_s) || @opp.board[target].fired_upon?
      return false
    end
    cell = @opp.board[target]
    find_empty(target, direction, length, (i + 1))
  end

  def state_InitialHit
    valid = false
    @initHit = @last
    tried = [false, false, false, false]
    direction = nil
    while !valid
      direction = rand(4)
      if direction == 0 && !tried[0] #up
        target = fetch_adjacent(@last, :up)
        tried[0] = true
      elsif direction == 1 && !tried[1] #right
        target = fetch_adjacent(@last, :right)
        tried[1] = true
      elsif direction == 2 && !tried[2] #down
        target = fetch_adjacent(@last, :down)
        tried[2]= true
      elsif direction == 3 && !tried[3] #left
        target = fetch_adjacent(@last, :left)
        tried[3] = true
      end
      valid = true if valid_target?(@opp, target)
      break if tried == [true, true, true, true]
    end
    if valid
      result = turn_result(@opp, target)
      if result == :hit
        @state = ([0, 2].include?(direction)) ? :vertical : :horizontal
        @last = target
      end
      return result
    else #Somehow there are no options. Give it a random go
      @state = :random
      return state_Random
    end
  end

  def state_Directed(horizontal = false)
    target = nil
    if horizontal
      test = fetch_adjacent(@last, :left)
    else
      test = fetch_adjacent(@last, :up)
    end
    target = test if valid_target?(@opp, test)
    if !target
        if horizontal
          test = fetch_adjacent(@last, :right)
        else
          test = fetch_adjacent(@last, :down)
        end
        target = test if valid_target?(@opp, test)
    end
    if !target #We buggered it, give up
      if @last == @initHit
          @state = :random
          return state_Random
      end
      @last = @initHit
      return state_Directed(horizontal)
    end
    result = turn_result(@opp, target)
    if result == :sunk
      @state = :random
    elsif result == :hit
      @last = target
    end
    return result
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
    end
    return target
  end

  def random_target(opp)
    opp.board.cells.keys.sample
  end

  def turn(opp)
    @opp = opp
    case @state
    when :random
      result = state_Random
    when :inithit
      result = state_InitialHit
    when :horizontal
      result = state_Directed(true)
    when :vertical
      result = state_Directed
    end

    return result
  end
end
