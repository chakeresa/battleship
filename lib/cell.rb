class Cell
    attr_reader :coord, :ship
    def initialize(coord)
        @coord = coord
        @ship
    end
    def place_ship(ship)
        @ship = ship
    end
    def empty?
        return @ship == nil
    end
end
