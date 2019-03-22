require 'minitest/autorun'
require 'minitest/pride'
require './lib/computer'
require './lib/player'

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

  def test_find_valid_target_always_finds_valid_target
    skip
    computer = Computer.new(2) # board is only A1-B2
    player = Player.new(2) # board is only A1-B2
    sub = Ship.new("sub", 2)

    player.board[:A1].ship = sub
    player.board[:A2].ship = sub
    actual = computer.place(sub)

    possibility1 = !computer.board[:A1].empty? && !computer.board[:A2].empty?
    possibility2 = !computer.board[:A1].empty? && !computer.board[:B1].empty?
    possibility3 = !computer.board[:B1].empty? && !computer.board[:B2].empty?
    possibility4 = !computer.board[:A2].empty? && !computer.board[:B2].empty?

    assert_equal :success, actual
    assert possibility1 || possibility2 || possibility3 || possibility4
  end

end
