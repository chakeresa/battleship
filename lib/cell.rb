require './lib/ship'

class Cell
    attr_reader :ship
    def initialize
        @ship = nil
        @fired = false
    end

    def place(ship)
        @ship = ship
    end

    def empty?
        return @ship == nil
    end

    def fired_upon?
        return @fired
    end

    def fire_upon
        if !self.empty?
            @ship.hit
        end
        @fired = true
    end

    def render(reveal = false)
        if self.empty?
            return @fired ? 'M' : '.'
        else
            if @fired
                return @ship.sunk? ? 'X' : 'H'
            else
                return reveal ? 'S' : '.'
            end
        end
    end
end
