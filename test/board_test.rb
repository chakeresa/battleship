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
                    A5: Cell.new, A6: Cell.new, A7: Cell.new, A8: Cell.new,
                    A9: Cell.new, A10: Cell.new,
                    B1: Cell.new, B2: Cell.new, B3: Cell.new, B4: Cell.new,
                    B5: Cell.new, B6: Cell.new, B7: Cell.new, B8: Cell.new,
                    B9: Cell.new, B10: Cell.new,
                    C1: Cell.new, C2: Cell.new, C3: Cell.new, C4: Cell.new,
                    C5: Cell.new, C6: Cell.new, C7: Cell.new, C8: Cell.new,
                    C9: Cell.new, C10: Cell.new,
                    D1: Cell.new, D2: Cell.new, D3: Cell.new, D4: Cell.new,
                    D5: Cell.new, D6: Cell.new, D7: Cell.new, D8: Cell.new,
                    D9: Cell.new, D10: Cell.new,
                    E1: Cell.new, E2: Cell.new, E3: Cell.new, E4: Cell.new,
                    E5: Cell.new, E6: Cell.new, E7: Cell.new, E8: Cell.new,
                    E9: Cell.new, E10: Cell.new,
                    F1: Cell.new, F2: Cell.new, F3: Cell.new, F4: Cell.new,
                    F5: Cell.new, F6: Cell.new, F7: Cell.new, F8: Cell.new,
                    F9: Cell.new, F10: Cell.new,
                    G1: Cell.new, G2: Cell.new, G3: Cell.new, G4: Cell.new,
                    G5: Cell.new, G6: Cell.new, G7: Cell.new, G8: Cell.new,
                    G9: Cell.new, G10: Cell.new,
                    H1: Cell.new, H2: Cell.new, H3: Cell.new, H4: Cell.new,
                    H5: Cell.new, H6: Cell.new, H7: Cell.new, H8: Cell.new,
                    H9: Cell.new, H10: Cell.new,
                    I1: Cell.new, I2: Cell.new, I3: Cell.new, I4: Cell.new,
                    I5: Cell.new, I6: Cell.new, I7: Cell.new, I8: Cell.new,
                    I9: Cell.new, I10: Cell.new,
                    J1: Cell.new, J2: Cell.new, J3: Cell.new, J4: Cell.new,
                    J5: Cell.new, J6: Cell.new, J7: Cell.new, J8: Cell.new,
                    J9: Cell.new, J10: Cell.new}

        assert_equal expected.keys, test.cells.keys
        #assert_equal expected.values, test.cells.values
    end

    def test_ship_placement_valid
        testBoard = Board.new
        testShip = Ship.new("test", 5)
        assert testBoard.place(testShip, 'B2', true)
        assert_equal [testShip], testBoard.ships
        0.upto(4) {|i| refute testBoard.cells[('B' + (2 + i).to_s).to_sym].empty?}
    end

    def test_ship_placement_out_bounds
        testBoard = Board.new
        testShip = Ship.new("test", 5)
        refute testBoard.place(testShip, 'B8', true)
        assert_equal [], testBoard.ships
        assert testBoard.cells[:B8].empty?
        assert testBoard.cells[:B10].empty?
    end

    def test_ship_placement_overlap
        testBoard = Board.new
        testShip = Ship.new("test", 5)
        testShip2 = Ship.new("bad", 5)
        assert testBoard.place(testShip, 'F5', true)
        refute testBoard.place(testShip2, 'E7')
        assert_equal [testShip], testBoard.ships
    end
end
