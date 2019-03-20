require 'minitest/autorun'
require './lib/board'

class BoardTest < Minitest::Test
    # initialize -> Board
        # Creates a new hash of new Cell objects, stored in @cells
        # Has associated attr_reader
        # Hash will contain each cell as a value to a Symbol key, where the key
        # is an X,Y coordinate, where X is a letter, and Y a number
    def test_board_init
        test = Board.new
        expected = {A1: Cell.new, A2: Cell.new, A3: Cell.new, A4: Cell.new,
                    B1: Cell.new, B2: Cell.new, B3: Cell.new, B4: Cell.new,
                    C1: Cell.new, C2: Cell.new, C3: Cell.new, C4: Cell.new,
                    D1: Cell.new, D2: Cell.new, D3: Cell.new, D4: Cell.new}

        assert_equal expected.keys, test.cells.keys
        #assert_equal expected.values, test.cells.values
    end
end