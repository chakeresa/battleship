require 'minitest/autorun'
require 'minitest/pride'
require './lib/computer'

class ComputerTest < Minitest::Test
  def test_it_exists
    computer = Computer.new

    assert_instance_of Computer, computer
  end

  def test_it_has_board_upon_init
    computer = Computer.new

    assert_instance_of Board, computer.board
  end

  def test_place_always_places_a_ship
    computer = Computer.new(2) # board is only A1-B2
    sub = Ship.new("sub", 2)

    actual = computer.place(sub)

    possibility1 = !computer.board[:A1].empty? && !computer.board[:A2].empty?
    possibility2 = !computer.board[:A1].empty? && !computer.board[:B1].empty?
    possibility3 = !computer.board[:B1].empty? && !computer.board[:B2].empty?
    possibility4 = !computer.board[:A2].empty? && !computer.board[:B2].empty?

    assert_equal :success, actual
    assert possibility1 || possibility2 || possibility3 || possibility4

  end

  def test_doesnt_place_a_ship_if_invalid_starting_coord
    skip
    computer = Computer.new(2) # board is only A1-B2
    sub = Ship.new("sub", 2)

    actual = computer.place_if_valid(sub, :C3, 0) # C3 and C4

    assert_equal :start_oob, actual
    assert computer.board[:A1].empty?
    assert computer.board[:A2].empty?
    assert computer.board[:B1].empty?
    assert computer.board[:B2].empty?
  end

  def test_doesnt_place_a_ship_if_invalid_later_coord
    skip
    computer = Computer.new(2) # board is only A1-B2
    sub = Ship.new("sub", 2)

    actual = computer.place_if_valid(sub, :B2, 0) # C3 and C4

    assert_equal :oob, actual
    assert computer.board[:A1].empty?
    assert computer.board[:A2].empty?
    assert computer.board[:B1].empty?
    assert computer.board[:B2].empty?
  end
end
