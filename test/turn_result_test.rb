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
end
