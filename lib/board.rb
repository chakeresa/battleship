require './lib/cell'

class Board
    attr_reader :cells, :ships, :size
    def initialize(size = 10)
        @cells = {}
        ('A'..(64+size).chr).each do |x| #As in x coord of graph
            ('1'..size.to_s).each do |y|
                @cells[(x+y).to_sym] = Cell.new
            end
        end
        @size = size
        @ships = []
    end
    def valid_coordinate?(coord)
        @cells.keys.any? {|cell| cell.to_s == coord}
    end
    def place(ship, coord, horizontal = false)
        #Test for out of bounds
            #Starting coordinate out of bounds?
        return false if coord[0] > (64 + @size).chr || coord[1].to_i > @size
            #Ending coordinate out of bounds?
        if horizontal
            #We only need to check the furthest coord from out start.
            return false if coord[1].to_i + ship.length > @size
        else
            return false if (coord[0].ord + ship.length).chr > (64 + @size).chr
        end
        #Test for overlap
        if horizontal
            0.upto(ship.length) do |i|
                at = (coord[0] + (coord[1].to_i + i).to_s).to_sym
                return false if !(@cells[at].empty?)
            end
        else
            0.upto(ship.length) do |i|
                at = ((coord[0].ord + i).chr + coord[1]).to_sym
                return false if !(@cells[at].empty?)
            end
        end
        #If tests passed, add ship
        @ships << ship
        if horizontal
            0.upto(ship.length) do |i|
                at = (coord[0] + (coord[1].to_i + i).to_s).to_sym
                @cells[at].place(ship)
            end
        else
            0.upto(ship.length) do |i|
                at = ((coord[0].ord + i).chr + coord[1]).to_sym
                @cells[at].place(ship)
            end
        end
        return true
    end
end
