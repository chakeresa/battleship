require 'minitest/autorun'
require './lib/board'

class BoardTest < Minitest::Test
    # initialize -> Board
        # Creates a new hash of new Cell objects, stored in @cells
        # Has associated attr_reader
        # Hash will contain each cell as a value to a Symbol key, where the key
        # is an X,Y coordinate, where X is a letter, and Y a number
    def test_board_init
      board = Board.new
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

      assert_equal expected.keys, board.cells.keys
      assert_instance_of Cell, board.cells[:A1]
      # Note: assert_equal expected.values, board.cells.values doesn't work
      # because the cell objects are created in the Board class, so these
      # are not the same exact objects
    end

    def test_ship_valid_horizontal_placement_returns_true
      board = Board.new
      ship = Ship.new("test", 2)

      actual = board.place(ship, 'B2', true) # B2 thru B3 (horizontal)

      assert actual
      assert_equal [ship], board.ships
      assert board.cells[:B1].empty?
      assert_equal false, board.cells[:B2].empty?
      assert_equal false, board.cells[:B3].empty?
      assert board.cells[:B4].empty?
    end

    def test_ship_valid_vertical_placement_returns_true
      board = Board.new
      ship = Ship.new("test", 2)

      actual = board.place(ship, 'B2', false) # B2 thru C2 (vertical)

      assert actual
      assert_equal [ship], board.ships
      assert board.cells[:A2].empty?
      assert_equal false, board.cells[:B2].empty?
      assert_equal false, board.cells[:C2].empty?
      assert board.cells[:D2].empty?
    end

    def test_ship_placement_out_bounds
      board = Board.new
      ship = Ship.new("test", 5)

      actual = board.place(ship, 'B8', true)

      assert_equal false, actual
      assert_equal [], board.ships
      assert board.cells[:B8].empty?
      assert board.cells[:B10].empty?
    end

    def test_ship_placement_false_if_overlap
      board = Board.new
      ship = Ship.new("test", 5)
      ship2 = Ship.new("bad", 5)

      board.place(ship, 'F5', true)
      actual = board.place(ship2, 'E7')

      assert_equal false, actual
      assert_equal [ship], board.ships
    end

    def test_out_of_bounds_returns_true_if_letter_starting_out_of_bounds
      board = Board.new(4)
      sub = Ship.new("Submarine", 2)

      assert board.out_of_bounds?(sub, 'Z4', true)
    end

    def test_out_of_bounds_returns_true_if_number_starting_out_of_bounds
      board = Board.new(4)
      sub = Ship.new("Submarine", 2)

      assert board.out_of_bounds?(sub, 'D9', true)
    end

    def test_out_of_bounds_returns_true_if_horizontal_ending_out_of_bounds
      board = Board.new(4)
      sub = Ship.new("Submarine", 2)

      assert board.out_of_bounds?(sub, 'D4', true)
    end

    def test_out_of_bounds_returns_true_if_vertical_ending_out_of_bounds
      board = Board.new(4)
      sub = Ship.new("Submarine", 2)

      assert board.out_of_bounds?(sub, 'D4', false)
    end

    def test_out_of_bounds_returns_false_if_horizontal_and_in_bounds
      board = Board.new(4)
      sub = Ship.new("Submarine", 2)

      assert_equal false, board.out_of_bounds?(sub, 'C3', true)
    end

    def test_out_of_bounds_returns_false_if_vertical_and_in_bounds
      board = Board.new(4)
      sub = Ship.new("Submarine", 2)

      assert_equal false, board.out_of_bounds?(sub, 'C3', false)
    end

    def test_overlap_returns_true_if_horizontal_and_first_cell_occupied

    end
end
