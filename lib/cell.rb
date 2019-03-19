require './ship'

class Cell
    attr_reader :coord, :ship
    def initialize(coord)
        @coord = coord
        @ship
        @fired = false
    end

    def place_ship(ship)
        @ship = ship
    end

    def empty?
        return @ship == nil
    end

    def fired_upon?
        return @fired
    end

    def fire_upon
        @ship.hit
        @fired = true
    end

end
