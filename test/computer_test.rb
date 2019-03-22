require 'minitest/autorun'
require 'minitest/pride'
require './lib/computer'
require './lib/player'
require './lib/cell'

class ComputerTest < Minitest::Test
  def test_it_exists
    computer = Computer.new("Wal-E")

    assert_instance_of Computer, computer
  end

  def test_it_has_board_upon_init
    computer = Computer.new("Short Circuit")

    assert_instance_of Board, computer.board
  end

  def test_place_always_places_a_ship
    computer = Computer.new("Short Circuit", 2) # board is only A1-B2
    sub = Ship.new("sub", 2)

    actual = computer.place(sub)

    possibility1 = !computer.board[:A1].empty? && !computer.board[:A2].empty?
    possibility2 = !computer.board[:A1].empty? && !computer.board[:B1].empty?
    possibility3 = !computer.board[:B1].empty? && !computer.board[:B2].empty?
    possibility4 = !computer.board[:A2].empty? && !computer.board[:B2].empty?

    assert_equal :success, actual
    assert possibility1 || possibility2 || possibility3 || possibility4
  end

  def test_places_a_second_ship
    computer = Computer.new("Wal-E", 2) # board is only A1-B2
    sub1 = Ship.new("sub", 2)
    sub2 = Ship.new("sub", 2)

    computer.place(sub1)
    actual = computer.place(sub2)

    possibility1 = computer.board[:A1].ship == sub1 && computer.board[:A2].ship == sub1 && computer.board[:B1].ship == sub2 && computer.board[:B2].ship == sub2
    possibility2 = computer.board[:A1].ship == sub2 && computer.board[:A2].ship == sub2 && computer.board[:B1].ship == sub1 && computer.board[:B2].ship == sub1
    possibility3 = computer.board[:A1].ship == sub1 && computer.board[:B1].ship == sub1 && computer.board[:A2].ship == sub2 && computer.board[:B2].ship == sub2
    possibility4 = computer.board[:A1].ship == sub2 && computer.board[:B1].ship == sub2 && computer.board[:A2].ship == sub1 && computer.board[:B2].ship == sub1

    assert_equal :success, actual
    assert possibility1 || possibility2 || possibility3 || possibility4
  end

  def test_places_a_ship_given_coord_and_dir
    computer = Computer.new("Wal-E", 3) # board is A1-C3
    sub1 = Ship.new("sub", 2)

    actual = computer.place(sub1, [:C2, true]) # C2 and C3

    assert_equal :success, actual
    assert computer.board[:C2].ship == sub1
    assert computer.board[:C3].ship == sub1
  end

  def test_rand_coord_and_direc_are_valid_cell_and_true_or_false
    computer1 = Computer.new("Short Circuit", 2) # board is only A1-B2

    coord, horizontal = computer1.rand_coord_and_direc

    assert coord == :A1 || coord == :A2 || coord == :B1 || coord == :B2
    assert horizontal == true || horizontal == false
  end

  def test_rand_coord_and_direc_are_random
    computer1 = Computer.new("Short Circuit", 2) # board is only A1-B2

    all_coord = []
    all_horizontal = []
    100.times do
      coord, horizontal = computer1.rand_coord_and_direc
      all_coord << coord
      all_horizontal << horizontal
    end

    assert all_coord.uniq.length != 1
    assert all_horizontal.uniq.length == 2
  end

  def test_find_valid_target_always_finds_valid_target
    computer1 = Computer.new("Short Circuit", 2) # board is only A1-B2
    computer2 = Computer.new("Wal-E", 2) # board is only A1-B2
    sub = Ship.new("sub", 2)

    computer2.place(sub, [:A1, true]) # A1 and A2
    computer1.find_valid_target(computer2, :A1)
    computer1.find_valid_target(computer2, :A2) # sinks computer2's sub
    actual = computer1.find_valid_target(computer2)

    assert actual == :B1 || actual == :B2
    assert computer2.board[:A1].ship.sunk? # or just sub.sunk?
  end

end
