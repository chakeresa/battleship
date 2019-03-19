require './cell'

class Board

    def initialize
        @board = {
            A: {
                1: Cell.new('A1'),
                2: Cell.new('A2'),
                3: Cell.new('A3'),
                4: Cell.new('A4')
            },
            B: {
                1: Cell.new('B1'),
                2: Cell.new('B2'),
                3: Cell.new('B3'),
                4: Cell.new('B4')
            },
            C: {
                1: Cell.new('C1'),
                2: Cell.new('C2'),
                3: Cell.new('C3'),
                4: Cell.new('C4')
            },
            D: {
                1: Cell.new('D1'),
                2: Cell.new('D2'),
                3: Cell.new('D3'),
                4: Cell.new('D4')
            }
        }
    end
end