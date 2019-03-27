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
            return @fired ? 'M' : "\e[38;5;33m.\e[m"
        else
            if @fired
                return @ship.sunk? ? "\e[31mX\e[m" : "\e[31mH\e[m"
            else
                return reveal ? "\e[33mS\e[m" : "\e[38;5;33m.\e[m"
            end
        end
    end
end
