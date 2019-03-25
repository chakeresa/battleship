require 'minitest/autorun'
require 'minitest/pride'
require './lib/turn_result' # also holds DummyTurnResult
require './lib/player'
require './lib/computer'

class TurnResultTest < Minitest::Test
  def test_it_exists
    mixin = DummyTurnResult.new

    assert_instance_of DummyTurnResult, mixin
  end

  def test_turn_result_returns_none_when_miss
    mixin = DummyTurnResult.new
    computer = Computer.new("COMPUTER 1", 2) # board is only A1-B2
    sub = Ship.new("sub", 2)

    computer.place(sub, [:A1, true]) # A1-A2
    computer.board[:B1].fire_upon
    actual = mixin.turn_result(computer, :B1)

    assert_equal :none, actual
  end

  def test_turn_result_returns_none_when_hit_but_not_end_game
    mixin = DummyTurnResult.new
    computer = Computer.new("COMPUTER 1", 2) # board is only A1-B2
    sub = Ship.new("sub", 2)

    computer.place(sub, [:A1, true]) # A1-A2
    computer.board[:A2].fire_upon
    actual = mixin.turn_result(computer, :A2)

    assert_equal :none, actual
  end

  def test_turn_result_returns_none_when_sunk_but_not_end_game
    mixin = DummyTurnResult.new
    computer = Computer.new("COMPUTER 1", 2) # board is only A1-B2
    sub = Ship.new("sub", 2)
    tinyboat = Ship.new("tinyboat", 1)

    computer.place(sub, [:A1, true]) # A1-A2
    computer.place(tinyboat, [:B1, true]) # just B1
    computer.board[:B1].fire_upon
    actual = mixin.turn_result(computer, :B1)

    assert_equal :none, actual
  end

  def test_turn_result_returns_win_when_end_game
    mixin = DummyTurnResult.new
    computer = Computer.new("COMPUTER 1", 2) # board is only A1-B2
    sub = Ship.new("sub", 2)

    computer.place(sub, [:A1, true]) # A1-A2
    computer.board[:A1].fire_upon
    computer.board[:A2].fire_upon
    actual = mixin.turn_result(computer, :A2)

    assert_equal :win, actual
  end

  def test_valid_target_returns_true_and_fires_upon_if_valid_target
    mixin = DummyTurnResult.new
    computer = Computer.new("COMPUTER 1", 2) # board is only A1-B2
    sub = Ship.new("sub", 2)

    computer.place(sub, [:A1, true]) # A1-A2
    actual = mixin.valid_target?(computer, :A2) # fires upon A2

    assert actual
    assert computer.board[:A2].fired_upon?
  end

  def test_valid_target_returns_false_if_target_already_fired_upon
    mixin = DummyTurnResult.new
    computer = Computer.new("COMPUTER 1", 2) # board is only A1-B2
    sub = Ship.new("sub", 2)

    computer.place(sub, [:A1, true]) # A1-A2
    computer.board[:A2].fire_upon # fires upon A2
    actual = mixin.valid_target?(computer, :A2) # fires upon A2

    assert_equal false, actual
    assert_equal false, computer.board[:A2].ship.sunk?
  end

  def test_valid_target_returns_false_if_invalid_coordinate
    mixin = DummyTurnResult.new
    computer = Computer.new("COMPUTER 1", 2) # board is only A1-B2
    sub = Ship.new("sub", 2)

    actual = mixin.valid_target?(computer, :C3)

    assert_equal false, actual
  end
end
