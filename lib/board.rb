require './lib/cell'

class Board
    attr_reader :cells, :ships, :size
    def initialize(size)
        @cells = {}
        ('A'..(64+size).chr).each do |x| #As in x coord of graph
            ('1'..size.to_s).each do |y|
                @cells[(x+y).to_sym] = Cell.new
            end
        end
        @size = size
        @ships = []
    end

    def [](at)
        return @cells[at]
    end

    def valid_coordinate?(coord)
        @cells.keys.any? {|cell| cell.to_s == coord}
    end

    def place(ship, coord, horizontal = false)
        return :oob if out_of_bounds?(ship, coord, horizontal)
        return :overlap if overlap?(ship, coord, horizontal)

        #If tests passed, add ship
        @ships << ship
        horizontal ? add_horizontal_ship(ship, coord) : add_vertical_ship(ship, coord)
        return :success
    end

    def out_of_bounds?(ship, coord, horizontal)
      #Starting coordinate out of bounds?
      return true if coord[0] > (64 + @size).chr || coord[1].to_i > @size

      #Ending coordinate out of bounds?
      if horizontal
          #We only need to check the furthest coord from out start.
          return coord[1].to_i + ship.length - 1 > @size
      else
          return (coord[0].ord + ship.length - 1).chr > (64 + @size).chr
      end

    end

    def overlap?(ship, coord, horizontal)
      if horizontal
          0.upto(ship.length - 1) do |i|
              at = (coord[0] + (coord[1].to_i + i).to_s).to_sym
              return true if !(@cells[at].empty?)
          end
      else
          0.upto(ship.length - 1) do |i|
              at = ((coord[0].ord + i).chr + coord[1]).to_sym
              return true if !(@cells[at].empty?)
          end
      end

      return false # if not overlapping
    end

    def add_horizontal_ship(ship, coord)
      0.upto(ship.length - 1) do |i|
          at = (coord[0] + (coord[1].to_i + i).to_s).to_sym
          @cells[at].place(ship)
      end
    end

    def add_vertical_ship(ship, coord)
      0.upto(ship.length - 1) do |i|
          at = ((coord[0].ord + i).chr + coord[1]).to_sym
          @cells[at].place(ship)
      end
    end
end
