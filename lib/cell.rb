require './lib/ship'

CELL_EMPTY = "\e[38;5;33m.\e[m"
CELL_MISS = "M"
CELL_HIT = "\e[31mH\e[m"
CELL_SHIP = "\e[38;5;136mS\e[m"
CELL_SUNK = "\e[38;5;29mX\e[m"

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
            return @fired ? CELL_MISS : CELL_EMPTY
        else
            if @fired
                return @ship.sunk? ? CELL_SUNK : CELL_HIT
            else
                return reveal ? CELL_SHIP : CELL_EMPTY
            end
        end
    end
end
